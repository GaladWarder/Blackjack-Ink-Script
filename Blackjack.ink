
VAR money = 100
VAR hand_value = 0
VAR knows_dealers_name = false
VAR bet = 0
VAR dealt_card = 0
VAR dealer_hand_value = 0

-> enter_casino

===function reveal_dealer_hand()===
~dealer_hand_value = RANDOM(12,21)
~return dealer_hand_value

===function look_at_hand()===
~hand_value = RANDOM(3,21)
~return hand_value

===function on_dealer_hit()===
~dealt_card = RANDOM(1,11)
~dealer_hand_value = dealer_hand_value + dealt_card
~return dealt_card

===function on_hit()===
~dealt_card = RANDOM(1,10)
~hand_value = hand_value + dealt_card
~return dealt_card

=== enter_casino ===

I find myself in a small, dark casino.
The rattle of chips and sounds of shuffling cards make me smile; this is my home.
* 	[Continue]

As I continue further inside, I come to a familiar table, the felt worn from hundreds of hands.
It's time for some Blackjack. -> blackjack_table

===blackjack_table===
I sit at my favorite chair, the one just in front of the dealer.
*	I glance at[ him] the elderly man who will be deciding my fate this evening.
	** [Continue]
		The battered nametag says 'Harold'.
		~ knows_dealers_name = true

*	I put my stack of bills[ down on the felt] on the table and settle into my chair.

-	{ knows_dealers_name:Harold|The dealer} grins at me, and gestures to the felt.

-> play_blackjack

===play_blackjack===

I look at my wad of cash - I have about ${money} in small bills.

+	{ money >= 5 }I put $5 into the betting circle.
	~money = money - 5
	~bet = 5
+	{ money >= 10 }I put $10 into the betting circle.
	~money = money - 10
	~bet = 10
+	{ money >= 20 }I put $20 into the betting circle.
	~money = money - 20
	~bet = 20
+	{ money >= 50 }I put $50 into the betting circle.
	~money = money - 50
	~bet = 50
+	I push the entire wad into the circle.
	Let's see if we can double this ${money}!
	~bet = money
	~money = 0
*	[Leave Casino]I stand up and leave the casino with ${money}.
	->leave_casino

-	{knows_dealers_name:Harold|The dealer} {~nods|smirks|grins|raises his eyebrow|smiles} at me and deals the cards.

+	I look at my hand...
	The well-worn cards add up to {look_at_hand()}.
	{ 
	-hand_value == 21:
		Blackjack! {knows_dealers_name:Harold|The dealer} gives me ${bet}!
		~money = money + bet * 2
		->play_blackjack
	-hand_value < 21 && hand_value > 17:
		I quickly motion that I will stand. No way am I going to take a hit with these odds!
		->dealers_hand
	-hand_value < 18:
		++	(hit) I motion to the dealer to hit.
			He deals me a {on_hit()}.
			{
			-hand_value == 21:
				Blackjack! {knows_dealers_name:Harold|The dealer} gives me ${bet}!
				~money = money + bet * 2
				->play_blackjack
			-hand_value > 21:
				I'm bust! There goes my ${bet}... 
				->play_blackjack

			-hand_value < 21 && hand_value > 17:
				I quickly motion that I will stand. No way am I going to take a hit with these odds!
				->dealers_hand

			-hand_value < 18:
				+++	[I motion to the dealer to hit.]
				->hit

				+++ [I choose to stand.]
				->stand
			}
		++	(stand) I choose to stand.[] Better to play it safe.
			-> dealers_hand
}
	
=dealers_hand
{knows_dealers_name:Harold|The dealer} looks at his hand. It totals {reveal_dealer_hand()}.
{
	-dealer_hand_value == 21:
	It's a blackjack! I sadly watch my bet slide away across the grimy felt.
	->play_blackjack

	-dealer_hand_value > hand_value && dealer_hand_value < 21:
	He's got me beat. My bet joins his stack on the other side of the table.
	->play_blackjack

	-dealer_hand_value == 17:
	{
		-hand_value > dealer_hand_value:
		I win! {knows_dealers_name:Harold|The dealer} counts out ${bet} and pushed it across the felt to me.
		~money = money + bet * 2
		->play_blackjack

		-else
		Looks like I lose this round.
		->play_blackjack
	}

	-dealer_hand_value < 17:
	He begrudgingly takes a hit. It's a {on_dealer_hit()}.
	{
		-dealer_hand_value == 21:
			Blackjack! There goes my bet...
			->play_blackjack

		-dealer_hand_value > 21:
			He's bust! I am {~reluctantly|begrudgingly|angrily} given ${bet}.
			~money = money + bet * 2
			->play_blackjack

		-dealer_hand_value < 21 && dealer_hand_value > 17:
			That puts him at {dealer_hand_value} against my {hand_value}.
			{
				-dealer_hand_value > hand_value:
				Looks like he wins this round.
				->play_blackjack

				-hand_value > dealer_hand_value:
				I win!
				~money = money + bet * 2
				->play_blackjack

				-else:
				It's a tie! The house wins.
				->play_blackjack
			}

		-dealer_hand_value < 17 && hand_value > dealer_hand_value:
			Strange...he's refusing to take another hit.
			Oh well, it's against the rules, but I win so I'm not going to complain.
			~money = money + bet * 2
			->play_blackjack

		-else
			{knows_dealers_name:Harold|The dealer} takes my bet and shoots me a{ smirk| threatening look| cheeky grin|n angry glare}. I guess I lose this round.
			->play_blackjack


	}
}

===leave_casino===
{
	-money > 100:
		I love this place. It seems like everytime I come here, I leave a bit richer.
		->END
	-money < 100:
		Today just wasn't my day. Maybe next time I'll win it back.
		->END
	-else:
		->END
}

-> END

