let project = new Project("SUI");

project.addAssets("Assets/**");
project.addShaders("Shaders/**");
project.addSources("Sources");

resolve(project);
