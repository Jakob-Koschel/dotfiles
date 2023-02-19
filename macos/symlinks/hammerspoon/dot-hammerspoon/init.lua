local spoons = {
	MuttWizard = {},
}

-- load spoons
for spoonName, spoonConfig in pairs(spoons) do
	hs.loadSpoon(spoonName)
	spoon[spoonName]:start(spoonConfig)
end
