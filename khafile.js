let project = new Project("SUI");

project.addAssets("Assets/**");
project.addShaders("Shaders/**");
project.addSources("Sources");
project.addParameter('-dce full');

// -> Compiler Flags
// --> Debugging 
project.addDefine('SUI_DEBUG_FPS');
// TODO:
// project.addDefine('SUI_DEBUG_CONSOLE');
// project.addDefine('SUI_DEBUG_GBUFFER');
// project.addDefine('SUI_DEBUG_BOUNDS');
// project.addDefine('SUI_DEBUG_LIGHTS');
// project.addDefine('SUI_DEBUG_COLLISIONS');

// --> Shading
project.addDefine('SUI_SHADING_DEFERRED');
// TODO:
// project.addDefine('SUI_SHADING_FORWARD');
// project.addDefine('SUI_SHADING_MIXED');

// --> Grouping
project.addDefine('SUI_BATCHING');
// project.addDefine('SUI_INSTANCING');

resolve(project);
