let project = new Project("SUI");

project.addAssets("Assets/**");
project.addShaders("Shaders/**");
project.addSources("Sources");
project.addParameter("-dce full");

// -> SUI Compiler Flags
// --> Debugging
project.addDefine("SUI_DEBUG_FPS");
// TODO:
// project.addDefine('SUI_DEBUG_BOUNDS');

// -> SUI STAGE2D Compiler Flags
// --> Debugging
// TODO:
// project.addDefine('SUI_STAGE2D_DEBUG_CONSOLE');
// project.addDefine('SUI_STAGE2D_DEBUG_GBUFFER');
// project.addDefine('SUI_STAGE2D_DEBUG_LIGHTS');
// project.addDefine('SUI_STAGE2D_DEBUG_COLLISIONS');

// --> Shading
project.addDefine("SUI_STAGE2D_SHADING_DEFERRED");
// TODO:
// project.addDefine('SUI_STAGE2D_SHADING_FORWARD');
// project.addDefine('SUI_STAGE2D_SHADING_MIXED');

// --> Misc
// project.addDefine("SUI_STAGE2D_BATCHING");

resolve(project);
