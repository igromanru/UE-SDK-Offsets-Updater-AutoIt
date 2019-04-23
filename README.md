# Unreal Engine SDK Offsets Updater - AutoIt version
The script can automatically update a C++ or C# class with a special format from an Unreal Engine SDK dump.

## Requirements
None, if you're using the compiled version.  

For the .au3 script:  
[AutoIt](https://www.autoitscript.com/site/autoit/downloads/) v3.3 or later

## How to use
Command to execute:
```bash
UE-SDK-Offsets-Updater.exe (path)/Offsets.h (path to SDK dump folder)/SDK
```
## How it works
The script reads through the file and looks for special comments. Comments defines which offset from which file and class we want to have. Then the script automatically updates the static constexp from the line below.  

Comment pattern:
```
// :(class name):(property name):(file name)
```
Example:
```cpp
// :APlayerController:PlayerCameraManager:SoT_Engine_classes.hpp
```
We want to get the offset from the property *PlayerCameraManager* in the class *APlayerController*. And the script should look for it in the file *SoT_Engine_classes.hpp*.  

Under the comment we need a static constexp int with following format:
```
static constexpr int (any property name) = 0x(anything);
```
Example:
```cpp
static constexpr int PlayerCameraManager = 0x0518;
```

The script automatically updates the offset **= 0x(here);**

### C++ class example

```cpp
class Offsets
{
public:
	// :APlayerController:PlayerCameraManager:SoT_Engine_classes.hpp
	static constexpr int PlayerCameraManager = 0x0518;

	// :AAthenaCharacter:WieldedItemComponent:SoT_Athena_classes.hpp
	static constexpr int WieldedItemComponent = 0x820;

...etc
}
```
