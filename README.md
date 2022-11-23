Odin project's "Mastermind". Decided to make bulls and cows, which is essentially the same game but without the visual flair.

I tried to implement swaszek's algorithm and I thought I correctly did so for a minute but in reality I made more of a brute force solution. It works, gets the correct guess on 8-11 tries on average and has a reasonable runtime, but it completely throws the inital guess '1122' out the window and it doesn't properly eliminate guesses.

For example, when it comes across a guess that returns a clue of 'two cows' it should know to eliminate any guesses that contain numbers that are NOT the two cows. So for example (A == cow) if 5352 is 5A5A, it should remove any possibilities that contain the number 5, because it now knows that 3 and 2 are now valid numbers to "keep" from a set of possibilites.

My solution just brute forces. It asks, "Is the current clue == all bulls?" If not, remove it. Which works. I'm not 100% clear why.

My project meets the requirements though and is not intended as a portfolio piece, so I'll likely come back to this when I understand algorithms a bit better.