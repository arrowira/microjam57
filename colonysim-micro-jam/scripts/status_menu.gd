extends Control



func configurestatus(industrialID, id, boost, baseOutput):
	if industrialID == 0:
		if id == 2:
			#void
			$Panel/statusText.text = "Void tile; unbuildable"
		elif id == 1:
			#fertile
			$Panel/statusText.text = "Fertile land; boosted farm outputs"
		elif id == 3:
			$Panel/statusText.text = "Sunny land; boosted power output"
		else:
			#normal
			$Panel/statusText.text = "normal land"
	else:
		if industrialID == 1:
			$Panel/statusText.text = "factory; +" + str(boost+baseOutput) + " metal/second"
		elif industrialID == 2:
			$Panel/statusText.text = "farm; +" + str(boost+baseOutput) + " food/second"
		elif industrialID == 3:
			$Panel/statusText.text = "house; -" + str(boost+baseOutput) + " food/second"
		elif industrialID == 4:
			$Panel/statusText.text = "power plant; +" + str(boost+baseOutput) + " power/second"
