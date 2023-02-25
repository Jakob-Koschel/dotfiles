local spoons = {
	MuttWizard = {
		auto_auth = true,
	},
}

-- enable cli
require("hs.ipc")
output = hs.ipc.cliInstall("~/.local", false)

-- load spoons
for spoonName, spoonConfig in pairs(spoons) do
	hs.loadSpoon(spoonName)
	spoon[spoonName]:start(spoonConfig)
end
