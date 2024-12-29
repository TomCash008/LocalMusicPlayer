require "import"
import "android.widget.*"
import "android.view.*"
import "android.media.*"
import "android.content.Intent"
import "android.net.Uri"
import "com.google.android.material.button.MaterialButton"
import "com.google.android.material.textview.MaterialTextView"
import "com.google.android.material.dialog.MaterialAlertDialogBuilder"
import "android.os.Handler"
import "android.widget.Toast"
import "android.view.Window"
import "android.view.WindowManager"

-- 隐藏标题栏
activity.getWindow().requestFeature(Window.FEATURE_NO_TITLE)
activity.getWindow().setFlags(
    WindowManager.LayoutParams.FLAG_FULLSCREEN,
    WindowManager.LayoutParams.FLAG_FULLSCREEN
)

-- 创建布局
layout = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "match_parent",
    layout_height = "match_parent",
    background = "#121212", -- 深色背景
    {
        MaterialTextView,
        id = "tvMusicName",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        text = "未选择文件",
        textSize = "18sp",
        gravity = "center",
        layout_marginTop = "32dp",
        textColor = "#FFFFFF", -- 白色文本
    },
    {
        MaterialButton,
        id = "btnSelectFile",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        text = "选择文件",
        layout_margin = "16dp",
        backgroundTint = "#BB86FC", -- 按钮背景颜色（浅紫色）
        textColor = "#FFFFFF", -- 按钮文字颜色（白色）
        cornerRadius = "16dp", -- 按钮圆角
    },
    {
        MaterialButton,
        id = "btnPlayPause",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        text = "播放",
        layout_margin = "16dp",
        backgroundTint = "#BB86FC", -- 按钮背景颜色（浅紫色）
        textColor = "#FFFFFF", -- 按钮文字颜色（白色）
        cornerRadius = "16dp", -- 按钮圆角
    },
    {
        SeekBar, -- 替换为 SeekBar
        id = "sbProgress",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        layout_margin = "16dp",
        progressDrawable = "#BB86FC", -- 进度条颜色
        thumbTint = "#BB86FC", -- 拖动块颜色
    },
    {
        MaterialTextView,
        id = "tvProgress",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        text = "00:00", -- 初始文本
        textSize = "14sp",
        textColor = "#FFFFFF", -- 白色
        gravity = "center",
        layout_marginTop = "8dp",
    },
    {
        MaterialTextView,
        id = "tvDuration",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        text = "00:00", -- 初始文本（总时长）
        textSize = "14sp",
        textColor = "#FFFFFF", -- 白色
        gravity = "center",
        layout_marginTop = "8dp",
    },
}

-- 设置主布局
activity.setContentView(loadlayout(layout))

local selectedFilePath = nil
local mediaPlayer = MediaPlayer()
local handler = Handler()
local updateRunnable
local isUserSeeking = false -- 标记用户是否正在拖动进度条

-- 文件选择逻辑
btnSelectFile.onClick = function()
    local intent = Intent(Intent.ACTION_GET_CONTENT)
    intent.setType("audio/*")
    activity.startActivityForResult(intent, 1)
end

function onActivityResult(requestCode, resultCode, data)
    if requestCode == 1 and resultCode == activity.RESULT_OK then
        local uri = data.getData() -- 获取文件 URI
        selectedFilePath = tostring(uri) -- 确保转换为字符串
        tvMusicName.setText(selectedFilePath)

        -- 每次选择文件后，重置并准备 MediaPlayer
        pcall(function()
            mediaPlayer.reset() -- 重置播放器
            mediaPlayer.setDataSource(activity, Uri.parse(selectedFilePath)) -- 设置数据源
            mediaPlayer.prepareAsync() -- 异步准备
        end, function(e)
            showToast("无法加载文件，请检查文件格式或权限")
        end)
    end
end

-- 播放/暂停逻辑
btnPlayPause.onClick = function()
    if selectedFilePath then
        if not mediaPlayer.isPlaying() then
            pcall(function()
                -- 如果播放器未播放，开始播放
                mediaPlayer.start() -- 继续播放
                btnPlayPause.setText("暂停")

                -- 启动进度条更新
                startUpdatingSeekBar()
            end, function(e)
                showToast("无法播放文件，请检查文件格式或权限")
            end)
        else
            mediaPlayer.pause() -- 暂停
            btnPlayPause.setText("播放")
            stopUpdatingSeekBar() -- 暂停时停止更新进度条
        end
    else
        showDialog() -- 未选择文件时弹出对话框提示
    end
end

-- 显示 Toast 提示信息
function showToast(message)
    Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
end

-- 显示选择文件提示对话框
function showDialog()
    local builder = MaterialAlertDialogBuilder(activity)
    builder.setMessage("请先选择一个音频文件")
    builder.setCancelable(false) -- 不允许取消

    -- 设置 "选择文件" 按钮
    builder.setPositiveButton("选择文件", function(dialog, id)
        -- 点击选择文件按钮时，直接调用文件选择的逻辑
        local intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.setType("audio/*")
        activity.startActivityForResult(intent, 1)
    end)

    -- 设置 "取消" 按钮
    builder.setNegativeButton("取消", function(dialog, id)
        dialog.dismiss()
    end)

    -- 显示对话框
    builder.show()
end

-- 进度条更新
function startUpdatingSeekBar()
    updateRunnable = Runnable{
        run = function()
            if mediaPlayer.isPlaying() and not isUserSeeking then
                local currentPosition = mediaPlayer.getCurrentPosition()
                sbProgress.setProgress(currentPosition)
                updateProgressText(currentPosition)
                handler.postDelayed(updateRunnable, 100) -- 每100毫秒更新一次进度条
            end
        end
    }
    handler.post(updateRunnable)
end

-- 更新进度条下面的数字显示
function updateProgressText(currentPosition)
    local minutes = math.floor(currentPosition / 60000)
    local seconds = math.floor((currentPosition % 60000) / 1000)
    tvProgress.setText(string.format("%02d:%02d", minutes, seconds))
end

-- 更新总时长显示
function updateDurationText(duration)
    local minutes = math.floor(duration / 60000)
    local seconds = math.floor((duration % 60000) / 1000)
    tvDuration.setText(string.format("%02d:%02d", minutes, seconds))
end

function stopUpdatingSeekBar()
    if updateRunnable then
        handler.removeCallbacks(updateRunnable) -- 停止进度条更新
    end
end

-- SeekBar 拖动事件监听
sbProgress.setOnSeekBarChangeListener{
    onStartTrackingTouch = function(seekBar)
        isUserSeeking = true -- 用户开始拖动进度条
    end,
    onStopTrackingTouch = function(seekBar)
        isUserSeeking = false -- 用户停止拖动进度条
        local seekToPosition = seekBar.getProgress()
        mediaPlayer.seekTo(seekToPosition) -- 设置音频播放位置
    end,
    onProgressChanged = function(seekBar, progress, fromUser)
        if fromUser then
            updateProgressText(progress) -- 实时更新进度文本
        end
    end,
}

-- 设置音频播放完毕后的回调
mediaPlayer.setOnCompletionListener(function(mp)
    btnPlayPause.setText("播放")
    stopUpdatingSeekBar() -- 播放完成后停止更新进度条
end)

-- 设置进度条最大值
mediaPlayer.setOnPreparedListener(function(mp)
    sbProgress.setMax(mp.getDuration()) -- 设置进度条的最大值为音频的时长
    updateDurationText(mp.getDuration()) -- 更新总时长显示
end)
