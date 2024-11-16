let project = new Project("SUI");

project.addAssets("Assets/**");
project.addLibrary("actuate");
project.addShaders("Shaders/**");
project.addSources("Sources");

resolve(project);
