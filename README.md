# PureLuaECS
简约的Lua ECS框架



使用方式：
Starter.lua是框架启动文件，直接加载即可启动框架


World.lua是整个游戏世界的管理器，需要外部调用Initialize函数进行初始化，并调用Update(deltaTime)函数进行更新。
