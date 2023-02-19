local spoons = {
	MuttWizard = {},
}

-- enable cli
require("hs.ipc")
output = hs.ipc.cliInstall('/Users/jkl/.local', false)

-- load spoons
for spoonName, spoonConfig in pairs(spoons) do
	hs.loadSpoon(spoonName)
	spoon[spoonName]:start(spoonConfig)
end
