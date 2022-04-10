extends MomArea

func action():
	# aggro_a -> TOOLS
	# aggro_b -> XBox
	# aggro_c -> TV
	# aggro_d -> cake/kitchen
	
	# Sonderende, Aggro a <= 2, Aggro B = 1, Aggro C = 1, Aggro D = 3 -> ganz böses Ende
	if Globals.aggro_a >= 2 and Globals.aggro_b_xbox == 1 and Globals.aggro_c == 1 and Globals.aggro_d == 3:
		yield(MessageSystem.show_message("mom", "HOLY SHIT BOB! YOU SICK LITTLE FUCK!", "mad"), "done");
		yield(MessageSystem.show_message("mom", "ALL TOOLS LAYING AROUND, LIVING ROOM LOOKS LIKE CRAP, ALMOST BURNED DOWN THE KITCHEN AND CALLED THE POLICE!", "mad"), "done");
		yield(MessageSystem.show_message("mom", "ARE YOU OUT OF YOUR MIND?", "mad"), "done");
		yield(MessageSystem.show_message("mom", "MAYBE YOU LEARN YOUR LESSON AFTER I SLAP THE LIVING SHIT OUT OF YOU AND PUT YOU IN THE ORPHANAGE!", "mad"), "done");
		yield(MessageSystem.show_message("bob", "Please don’t Mom!", "neutral"), "done");
		yield(MessageSystem.show_message("mom", "*SLAP*", "mad"), "done");
		yield(MessageSystem.show_message("mom", "YOU MADE ME DO THIS!", "mad"), "done");

	# Sonderende, Aggro a = 0, Aggro B = -1, Aggro C = 0, Aggro D = 2 -> ganz liebes Ende
	elif Globals.aggro_a == 0 and Globals.aggro_b_xbox == -1 and Globals.aggro_c == 0 and Globals.aggro_d == 2:
		yield(MessageSystem.show_message("mom", "Good evening Bob, I just wanted to tell you, that you are my sunny honey bunny.", "happy"), "done");
		yield(MessageSystem.show_message("mom", "My best friend was on the phone and I ate your cake.", "happy"), "done");
		yield(MessageSystem.show_message("mom", "I feel so good, I think I might cancel the divorce and we can be a happy family again.", "happy"), "done");
		yield(MessageSystem.show_message("bob", "Happyness intensifies!", "happy"), "done");

	# "Normale" Enden
	else:
		if Globals.aggro_a == 0:
			yield(MessageSystem.show_message("mom", "Hello honey, I just came back.", "neutral"), "done");
			yield(MessageSystem.show_message("bob", "Hello mom.", "neutral"), "done");
		elif Globals.aggro_a == 1:
			yield(MessageSystem.show_message("mom", "Hello honey, I just came back... Have you put a tool from the shack on the trail?", "neutral"), "done");
			yield(MessageSystem.show_message("bob", "Yeah, I am sorry. I wanted to play with it.", "neutral"), "done");
		else:
			yield(MessageSystem.show_message("mom", "Hello honey, I just came back and all our tools were laying on the ground in our yarn. What was that for?!?", "mad"), "done");
			yield(MessageSystem.show_message("bob", "Uhm...", "neutral"), "done");
		
		if Globals.aggro_b_xbox == 0 and Globals.aggro_c == 0:
			yield(MessageSystem.show_message("mom", "The living room looks a bit messy, have you shifted the furniture?", "neutral"), "done");
			yield(MessageSystem.show_message("bob", "I've searched the remote.", "neutral"), "done");
		elif Globals.aggro_b_xbox == 1 and Globals.aggro_c == 0:
			yield(MessageSystem.show_message("mom", "The living room looks like a mess and you let your god damn Nintendo on again!", "mad"), "done");
			yield(MessageSystem.show_message("bob", "Sorry mom...", "neutral"), "done");
		elif Globals.aggro_b_xbox == 1 and Globals.aggro_c == 1:
			yield(MessageSystem.show_message("mom", "The living room looks like a mess, you let that stupid Nintendo on, and you called the police?", "mad"), "done");
			yield(MessageSystem.show_message("mom", "What were you thinking today?!?", "mad"), "done");
			yield(MessageSystem.show_message("bob", "I am so sorry mom...", "neutral"), "done");
		elif Globals.aggro_b_xbox == 0 and Globals.aggro_c == 1:
			yield(MessageSystem.show_message("mom", "The living room looks like a mess and you called the police, did something happen?", "mad"), "done");
			yield(MessageSystem.show_message("mom", "Or is this one of your infamous jokes?", "mad"), "done");
			yield(MessageSystem.show_message("bob", "I thought there was a burglar, but it was a misconception.", "neutral"), "done");

		if Globals.aggro_d == 1:
			yield(MessageSystem.show_message("mom", "And you also left grocies on the kitchen table. Have you tried to cook something?", "neutral"), "done");
			yield(MessageSystem.show_message("bob", "I uhm... Wanted to be a good boy but don’t know how to cook.", "neutral"), "done"); 
		if Globals.aggro_d == 2:
			yield(MessageSystem.show_message("mom", "But you are still my little sweety because you made me a cake! That was so nice of you, I love you for today.", "happy"), "done");
			yield(MessageSystem.show_message("bob", "Thank you, live giver!", "happy"), "done"); 
		if Globals.aggro_d == 3:
			yield(MessageSystem.show_message("mom", "And you little retard left something in the oven that almost burned down the kitchen!", "mad"), "done");
			yield(MessageSystem.show_message("bob", "I'm so sorry, please don’t hit me.", "neutral"), "done"); 

		if Globals.time_delayed < 60:
			yield(MessageSystem.show_message("mom", "...Oh no, look at your room! It looks so bad, I have not raised you like this!", "mad"), "done");
			yield(MessageSystem.show_message("mom", "Maybe you will learn your lesson after a week of no lunch!", "mad"), "done");
			yield(MessageSystem.show_message("bob", "Oh no! Please not again!", "neutral"), "done");
		elif Globals.time_delayed < 120:
			yield(MessageSystem.show_message("mom", "Mh... your room also doesn’t look so good... but it could be worse I guess.", "neutral"), "done");
			yield(MessageSystem.show_message("mom", "Come, I´ll make you some lunch.", "neutral"), "done");
			yield(MessageSystem.show_message("bob", "Yay! I love you!", "happy"), "done");
		else:
			yield(MessageSystem.show_message("mom", "Wait... your room looks like the Caesars Palace. My sweet little boy.", "happy"), "done");
			yield(MessageSystem.show_message("mom", "Today you will get two lunches.", "happy"), "done");
			yield(MessageSystem.show_message("bob", "Oh boy! Double nutrition = Double gains!", "happy"), "done");


	yield(MessageSystem.show_message("bob", "Thank you for playing!", "happy"), "done");
	
	var cl = get_tree().get_nodes_in_group("end-canvas-layer")[0];
	cl.visible = true;
	
	return .action();
