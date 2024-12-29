# 音频播放器应用介绍 (Audio Player App Introduction)

## 软件概述 (Overview)

这款软件是一个简易的音频播放器，用户可以通过它选择音频文件、控制音频的播放与暂停，并通过进度条来查看和控制音频播放进度。它具有以下主要功能：

- <span style="color: #BB86FC;">选择音频文件</span>：通过内置的文件选择器，用户可以选择本地存储中的音频文件进行播放。
- <span style="color: #BB86FC;">播放与暂停控制</span>：用户可以通过一个按钮控制音频的播放和暂停。
- <span style="color: #BB86FC;">音频播放进度控制</span>：通过进度条（SeekBar），用户可以实时查看和调整当前播放的位置。
- <span style="color: #BB86FC;">显示当前时间与总时长</span>：显示音频的当前播放时间和总时长，帮助用户精准控制播放位置。

## 主要功能 (Main Features)

### 1. 全屏无标题模式 (Fullscreen Mode)
应用启动后，默认会隐藏设备的标题栏，并以全屏模式运行，给用户带来更沉浸的体验。

### 2. 选择文件 (Choose File)
- 当用户点击“选择文件”按钮时，系统会启动一个文件选择器，允许用户从设备中选择一个音频文件。当前只支持选择 `audio/*` 类型的文件。
- 选择音频文件后，文件路径会显示在界面上，同时播放器会准备好该音频文件以便播放。

### 3. 播放/暂停 (Play/Pause)
- 用户可以点击“播放”按钮开始音频播放。如果音频正在播放，按钮文本会变为“暂停”，用户可以暂停播放。暂停后进度条更新会停止，直到用户再次点击播放。

### 4. 音频进度条 (Audio Progress Bar)
- **进度条（SeekBar）**：应用通过一个进度条显示当前音频的播放进度。用户可以拖动进度条来调整播放位置。拖动时，进度条和时间文本会实时更新。
- 进度条的最大值为音频文件的总时长。

### 5. 音频总时长和当前进度 (Total Duration and Current Progress)
- 在界面上方会显示当前播放进度，格式为“分钟:秒数”，下方显示音频文件的总时长。
- 播放器会定时更新当前播放进度，用户也可以直接通过进度条调整。

### 6. 提示与错误处理 (Error Handling)
- 当用户未选择音频文件时，点击播放按钮会弹出提示对话框，提示用户先选择一个音频文件。
- 如果出现文件加载失败或播放失败的情况，会弹出提示信息，提醒用户检查文件格式或权限。

### 7. 全局控制 (Global Controls)
- 进度条的拖动事件会影响音频播放的位置。用户在拖动时，播放进度和显示的时间会同步更新。

### 8. 音频播放完毕后自动重置 (Auto Reset After Playback)
- 音频播放完毕后，播放按钮会变回“播放”状态，进度条更新停止，并且可以重新开始播放。

## 技术细节 (Technical Details)

- **界面布局**：界面采用了 **Material Design** 风格，包括 `MaterialTextView` 和 `MaterialButton` 控件，界面设计简洁且现代。
- **多线程更新**：应用通过 `Handler` 和 `Runnable` 对象定时更新进度条，确保进度条的实时同步。
- **音频播放**：使用 **MediaPlayer** 进行音频播放，支持异步加载音频文件，自动更新播放进度和总时长。
- **权限处理**：文件选择时，应用需要访问存储权限。文件选择成功后，应用会检查文件路径的有效性，并加载音频文件。

## 用户界面 (User Interface)

- **标题栏和背景**：应用以深色背景呈现，界面简洁且现代，确保用户在使用时不会感到视觉疲劳。
- **按钮与进度条**：界面包括“选择文件”和“播放/暂停”按钮，按钮颜色和文字颜色符合现代设计规范，易于操作。进度条配有滑块和时间显示，方便用户查看和调整音频播放进度。

## 错误与异常处理 (Error and Exception Handling)

- 应用在加载音频文件时做了异常处理，确保在文件格式不兼容或权限不足的情况下，能够给出友好的提示。
- 若用户没有选择音频文件而直接点击播放，应用会弹出提示对话框，避免无效操作。

## 总结 (Summary)

这款音频播放器应用功能全面，界面简洁直观，能够让用户轻松地选择音频文件进行播放和控制播放进度。它适合用作一个基本的音频播放器，且具有一定的扩展性，可以进一步加入更多音频控制功能或其他类型的文件支持。

---

## English Version:

This app is a simple audio player that allows users to choose audio files, control playback, and use a progress bar to track and adjust the audio playing position. It offers the following key features:

- **Choose Audio Files**: Users can select audio files from local storage using an in-built file picker.
- **Play/Pause Control**: A button is provided to play or pause the audio.
- **Audio Progress Control**: The app shows and allows users to adjust the audio playing position via a SeekBar.
- **Show Current Time and Total Duration**: Displays the current playback time and total duration, allowing users to control the playback position accurately.

## Main Features

### 1. Fullscreen Mode
Upon launch, the app hides the title bar and operates in fullscreen mode for a more immersive experience.

### 2. File Selection
- When users click "Choose File," a file picker opens to allow users to select an audio file. Only `audio/*` files are supported.
- After selecting an audio file, the file path is displayed on the interface, and the player prepares the file for playback.

### 3. Play/Pause
- Users can click the "Play" button to start audio playback. When playing, the button text changes to "Pause," and users can pause playback. When paused, the progress bar stops updating until "Play" is clicked again.

### 4. Audio Progress Bar
- **SeekBar**: The app uses a SeekBar to show the current playback progress. Users can drag the SeekBar to adjust the position. The progress bar and time text are updated in real-time.
- The maximum value of the SeekBar is the total duration of the audio file.

### 5. Total Duration and Current Progress
- The current playback progress is displayed at the top in "minute:second" format, with the total audio duration displayed below.
- The player updates the current progress periodically, and users can adjust it directly via the SeekBar.

### 6. Error Handling
- If no audio file is selected, clicking the play button triggers a prompt asking users to select a file first.
- If the file fails to load or play, a message will appear prompting users to check the file format or permissions.

### 7. Global Controls
- Dragging the SeekBar affects the audio playback position. During dragging, the progress and time are updated in sync.

### 8. Auto Reset After Playback
- After the audio finishes playing, the play button resets to "Play" mode, and the progress bar stops updating, allowing users to start playback again.

## Technical Details

- **Interface Layout**: The app uses a **Material Design** style, with `MaterialTextView` and `MaterialButton` controls for a modern and clean design.
- **Multithreaded Updates**: The app uses a `Handler` and `Runnable` to update the SeekBar, ensuring real-time synchronization.
- **Audio Playback**: **MediaPlayer** is used for audio playback, supporting asynchronous file loading, and automatic progress and duration updates.
- **Permission Handling**: The app requests storage permissions to access and select files, ensuring the file path is valid before loading the audio.

## User Interface

- **Title Bar and Background**: The app features a dark background and modern design to reduce visual fatigue.
- **Buttons and SeekBar**: It includes "Choose File" and "Play/Pause" buttons, adhering to modern design standards for easy operation. The SeekBar includes a slider and time display for convenient adjustment of the audio progress.

## Error and Exception Handling

- The app handles errors during audio file loading to provide helpful messages when there are format or permission issues.
- If no audio file is selected, a prompt appears when users try to play without selecting a file.

## Summary

This audio player app is feature-rich and easy to use, allowing users to quickly select an audio file, play it, and control the playback progress. It's an excellent basic audio player with potential for further expansion to include additional features and support for other file types.
