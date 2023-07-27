# Vision OSC

= PoseOSC + FaceOSC + HandOSC + OcrOSC + CatOSC + DogOSC

**[下载](https://github.com/LingDong-/VisionOSC/releases)** | **[例子](demos/VisionOSCProcessingReceiver/VisionOSCProcessingReceiver.pde)**

**[English](./README.md)**

通过OSC发送（几乎）所有苹果[Vision](https://developer.apple.com/documentation/vision)框架的检测结果。（您可以选择要检测和发送的内容）。使用Objective-C++编写，运行在[openFrameworks](https://openframeworks.cc/)上。仅适用于macOS 11+。

![](screenshots/screenshot000.png)

受[PoseOSC](https://github.com/LingDong-/PoseOSC)启发，但更快，不再使用电子应用的冗余或奇怪的噪声处理。兼容PoseOSC的`ARR`格式。

## 如何在Xcode中重新构建项目：

除非绝对必要，否则请不要尝试(使用projectGenerator)重新构建项目，如果确实需要重新构建，请按照以下步骤进行：

- File > Project Settings, Build System -> New Build System
- Left sidebar, click project name, General > Frameworks, Libraries,... Add Vision, AVKit, Foundation, AVFoundation, CoreML
- Build Phases, Link Binary with Libraries, Change "mac catalyst" to "always"
- Change deployment target to 11.3
- For each file in src folder, on right sidebar, change file "Type" to Objective C++ (not extension, just in the dropdown menu)


如果您遇到`Undefined symbol: __objc_msgSend$identifier`错误，您可能需要设置`Excluded Architectures arm64`。详细信息请参考[此问题](https://github.com/LingDong-/VisionOSC/issues/2)

如果遇到有关ARC（Automatic Reference Counting）的一些问题，您可能需要在`src`文件夹中删除所有关于 `autorelease`的提及。

## 使用方法：

在启动时将加载`settings.xml`中的设置。

在打包的应用程序中，`settings.xml`文件可以在`Contents/Resources`目录下找到。

可以查看[demos/VisionOSCProcessingReceiver](demos/VisionOSCProcessingReceiver)来了解一个使用[Processing](https://processing.org/)演示的示例，用于接收所有的检测类型。

### 从OSC接收姿势数据的步骤如下：

这与[`ARR`格式是PoseOSC的一种数据格式](https://github.com/LingDong-/PoseOSC#method-4-arr)相同，内容如下

姿势数据将作为值数组发送到 `poses/arr` OSC地址（OSC规范允许每个地址有多个不同类型的值）。

- 第一个值（int）是帧的宽度。
- 第二个值（int）是帧的高度。
- 第三个值（int）是姿势的数量（当读取此值时，您将知道还有多少个值要读取，即`nPoses*(1+17*3)`。所以，如果这个数字为0，表示没有检测到姿势，您可以停止读取）。
- 接下来的52个值是第一个姿势的数据，接着的52个值是第二个姿势的数据（如果有的话），依此类推...
- 对于每个姿势，第一个值（float）是该姿势的得分，其余的51个值（floats）可以分成17组，每组包含一个关键点的(x，y，score)。有关关键点的顺序，请参阅[PoseNet规范](https://github.com/tensorflow/tfjs-models/tree/master/posenet)。

### 从OSC接收面部数据

与姿势格式类似（见上文）；发送到`faces/arr` OSC地址：

- 第一个值（int）是帧的宽度。
- 第二个值（int）是帧的高度。
- 第三个值（int）是面部的数量。
- 接下来的229个值是第一个面部的数据，接下来的229个值是第二个面部的数据（如果有的话），依此类推...
- 对于每个面部，第一个值（float）是该面部的得分，其余的228个值（floats）可以分成76组，每组包含一个关键点的(x，y，score)。


### 从OSC接收手部数据

与姿势格式类似（见上文）；发送到hands/arr OSC地址：

- 第一个值（int）是帧的宽度。
- 第二个值（int）是帧的高度。
- 第三个值（int）是手部的数量。
- 接下来的64个值是第一个手部的数据，接下来的64个值是第二个手部的数据（如果有的话），依此类推...
- 对于每个手部，第一个值（float）是该手部的得分，其余的63个值（floats）可以分成21组，每组包含一个关键点的(x，y，score)。有关关键点的顺序，请参阅[handpose规范](https://google.github.io/mediapipe/solutions/hands.html)

### 从OSC接收文字（OCR）数据

发送到texts/arr OSC地址：

- 第一个值（int）是帧的宽度。
- 第二个值（int）是帧的高度。
- 第三个值（int）是文字区域的数量。
- 接下来的6个值是第一个文本的数据，接下来的6个值是第二个文本的数据（如果有的话），依此类推...
- 对于每个文本，第一个值（float）是该文本的得分，接下来的四个值（float）是边界框的（left，top，width，height）。最后一个值是文本的内容（字符串）。

### 从OSC接收动物检测数据

目前仅支持猫和狗，详见 [Apple的文档](https://developer.apple.com/documentation/vision/vnanimalidentifier)。

与文字格式类似（见上文）；发送到`animals/arr`OSC地址：

- 第一个值（int）是帧的宽度。
- 第二个值（int）是帧的高度。
- 第三个值（int）是动物的数量。
- 接下来的6个值是第一个动物的数据，接下来的6个值是第二个动物的数据（如果有的话），依此类推...
- 对于每个动物，第一个值（float）是该动物的得分，接下来的四个值（float）是边界框的（left，top，width，height）。最后一个值是动物的类型（字符串）：“Cat”/“Dog”。
- PoseOSC支持的JSON和XML格式现已被排除，因为我后来意识到添加这种解析开销是一个愚蠢的想法。如果您对这个决定有异议，请告诉我。

我推荐使用 [Protokol](https://hexler.net/protokol)进行OSC的测试/检查。- 

## 帧率

在MacBook Pro (13-inch, M1, 2020) 内存16 GB上测试的帧率：

- 人体姿势：60 FPS
- 手部姿势：60 FPS
- 面部姿势：45 FPS
- 文本：10 FPS
- 动物：60 FPS
- 面部、人体和手部姿势：25 FPS
- 所有功能同时运行：5 FPS



