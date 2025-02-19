%This line is needed so you can modify the variables with these predicates
:- dynamic item_at/2, here/1, restart/0.
:- dynamic has_armor/1, buy/1, craft/1.

%Predicate used to say which room we are currently in
here(entrance).

%Predicae to track armor
has_armor(false).

% Predicate to restart the game
restart :-
    retractall(item_at(_, _)),
    retractall(here(_)),
    retractall(has_armor(_)),
    assert(here(entrance)),
    assert(item_at(torch, torch_room)),
    assert(item_at(sword, treasure_room)),
    assert(item_at(musicbox, treasure_room)),
    assert(item_at(foldOption, dog_Poker)),
    assert(item_at(callOption, dog_Poker)),
    assert(item_at(cobweb, spider_den)),
    assert(item_at(painting, white_room)),
    assert(item_at(sticks, hermit)),
    assert(item_at(staff, hermit)),
    assert(item_at(arrows, skeleton)),
    write('Restarting the game...'), nl,
    start.


%series of predicates that tells us how the rooms are connected
move_to(entrance, n, torch_room).
move_to(torch_room, s, entrance).
move_to(entrance, w, dark_room) :- item_at(torch, in_hand).
move_to(entrance, w, dark_room) :- write('Cannot go in there. It is too dark!'), nl, !, fail.
move_to(dark_room, e, entrance).

%dragon stuff
move_to(dark_room, n, treasure_room).
move_to(dark_room, w, dog_Poker) :- write('You make a dash for the west entrance, you are eaten by the dragon. GAME OVER!'), nl, restart, !, fail.
move_to(treasure_room, s, dark_room) :- item_at(sword, in_hand), write('You lunge at the dragon with a sword...a dragon...GAME OVER!'), nl, restart, !, fail.
move_to(treasure_room, s, dog_Poker) :- write('You crank up the old music box and it plays a lullaby. To your disbelief, it puts the dragon to sleep, clearing the entrance west.').

%dog poker and shop

move_to(dog_Poker, w, shop) :- item_at(foldOption, in_hand), write('You folded and won nothing, you then go to the next room and it\'s a shop ran by a dog. You check out the armor prices and to your disappointment you see the currency is in poker chips, if only you gambled...').
move_to(dog_Poker, w, shop) :- item_at(callOption, in_hand), write('You called all the dogs bluffs and win with a full house. You go to the next room and see its a shop ran by a dog selling armor in chips... you have enough chips to buy armor.').
move_to(dog_Poker, w, _) :- write('99 of gamblers quit before they hit it big, you should have gambled...the dogs say as they slowly approach...GAME OVER!'), nl, restart, !, fail.

%cobwebs and caveman
move_to(shop, w, spider_den).
move_to(spider_den, n, caveman).
move_to(spider_den, e, shop).
move_to(caveman, s, spider_den).
move_to(caveman, n, white_room).
move_to(white_room, s, caveman).
move_to(white_room, n, hidden_ending) :- item_at(painting, in_hand).
move_to(white_room, n, hidden_ending) :- write('You walk up to the painting for a closer look...beautiful'), nl, !, fail.
move_to(white_room, e, hermit).

%from shop up
move_to(shop, n, skeleton).
move_to(skeleton, s, shop).
move_to(skeleton, n, craft_room).
move_to(craft_room, s, skeleton).
move_to(craft_room, n, hermit).
move_to(hermit, w, white_room).
move_to(hermit, s, craft_room).

%closed off
move_to(shop, e, dog_Poker) :- write('You cannot go back that way, the entrance caved in'), nl, !, fail.
move_to(dog_Poker, e, dark_room) :- write('You cannot go back that way, the entrance caved in'), nl, !, fail.


% Final boss room logic
move_to(craft_room, e, boss) :-
    has_armor(true),
    item_at(bow, in_hand),
    item_at(arrows, in_hand),
    write('You walk into the boss room facing a large purple minion. You prepare for battle.'),
    write('With your armor equipped and bow in hand, you face the evil purple minion.'), nl,
    write('You skillfully shoot an arrow, taking down the minion!'), nl,
    write('The ceiling above collapses, revealing a way out. You climb through the hole and escape! YOU WIN!'), nl,
    restart, !, fail.

move_to(craft_room, e, boss) :-
    \+ has_armor(true),
    item_at(bow, in_hand),
    item_at(arrows, in_hand),
    write('You walk into the boss room containing a large purple minion. You prepare to fight.'), nl,
    write('With your bow and arrows, you fire at the minion and land a hit.'), nl,
    write('But without armor, you cannot withstand the minion\'s counterattack. You fall.'), nl,
    write('GAME OVER.'), nl,
    restart, !, fail.

move_to(craft_room, e, boss) :-
    item_at(staff, in_hand),
    write('You walk into the boss room containing a large purple minion. You prepare to fight.'), nl,
    write('You point the staff at the evil minion, but nothing happens...'), nl,
    write('The low-battery light blinks mockingly. The minion lunges at you, and you cannot escape...'), nl,
    write('GAME OVER.'), nl,
    restart, !, fail.

move_to(craft_room, e, boss) :-
    has_armor(true),
    (\+ item_at(bow, in_hand) ; \+ item_at(arrows, in_hand)),
    write('You stand frozen with fear, as you just walked into the boss room containing a giant purple minion. You have nothing besides relying on your armor...but it\'s not enough.'), nl,
    write('The minion crushes you mercilessly.'), nl,
    write('GAME OVER.'), nl,
    restart, !, fail.

% Default ending if player enters boss room without any items
move_to(craft_room, e, boss) :-
    \+ has_armor(true),
    \+ item_at(bow, in_hand),
    \+ item_at(arrows, in_hand),
    \+ item_at(staff, in_hand),
    write('You enter the boss room unprepared. It\'s a giant purple minion! The evil minion laughs and swiftly takes you down.'), nl,
    write('GAME OVER.'), nl,
    restart, !, fail.




%predicates that shows which rooms the items exist in
item_at(torch, torch_room).

%dragon items added
item_at(sword, treasure_room).
item_at(musicbox, treasure_room).

%dog poker and shop stuff
item_at(foldOption, dog_Poker).
item_at(callOption, dog_Poker).

%cobweb
item_at(cobweb, spider_den).

%painting
item_at(painting, white_room).

%hermit
item_at(sticks, hermit).
item_at(staff, hermit).
item_at(arrows, skeleton).


%the take() predicates allow us to pick up an item.
take(Item) :-
	item_at(Item, in_hand),
	write('You already have it'),
	nl, !.

take(Item) :-
	here(Place),
	item_at(Item, Place),
	retract(item_at(Item, Place)),
	assert(item_at(Item, in_hand)),
	write('OK.'),
	nl, !.

take(_) :-
	write('You do not see that here.'), nl.


%the describe() predicates give the room descriptions
describe(entrance) :-
	write('You are at the cave entrance'), nl,
	write('The obvious exits are north and west.').

describe(torch_room) :-
	write('You enter room in the cave.'),nl,
	write('There is a painting on the northern wall.'), nl,
	write('The only exit is back south.').

describe(dark_room) :-
	write('You enter a damp, dark room.'),nl,
	write('You are immediately greeted by a large, red dragon, eyeing you suspicously blocking the main entrance west'), nl,
	write('To the north, you notice a hole in the wall.').

%dragon rooms descriptions
describe(treasure_room) :-
	write('You enter through the hole in the wall, revealing an old treasure room.'), nl,
	write('Everything looks unusable aside from a shiny sword with a golden hilt, and a music box.'), nl,
	write('Which do you pick up? The sword or musicbox?'), nl,
        write('The only exit is south.').

%poker and shop
describe(dog_Poker) :-
	write('You see the famous dogs playing poker in front of the ONLY way west, they invite you over for a round, you must play or else...'), nl,
	write('You are given the worst hand in poker, 7-deuce. To your surprise, all the dogs go all-in pre-flop!'), nl,
	write('Do you decide to go with the option fold, or option call?'), nl,
        write('The only exit is west (after you take(x) one of the choices go west for the result.').

describe(shop) :-
    item_at(callOption, in_hand),
    \+ has_armor(true),
        write('You can buy the armor (type `buy(armor).`) or leave by taking the tunnel west or door north.'), nl, !.

describe(shop) :-
    has_armor(true),
    write('You are in the shop. You already purchased armor.'), nl,
    write('You can leave by going west or north.'), nl, !.

describe(shop) :-
    write('He has nothing else to offer you. You can leave by going west or north.'), nl.

%cobweb and caveman
describe(spider_den) :-
    write('You walk into a cavern filled with cobwebs and punch of spider sacks filled with what you assume are some unlucky souls.'), nl,
    write('You feel the urgency to leave before the spiders return, you can go north or go east.'), nl,
    write('Maybe you could take some cobwebs...').

describe(caveman) :-
    write('You walk into another portion of the cavern where the walls are covered in caveman drawings.'), nl,
    write('None of them really stand out to you besides one of them being a giant purple splotch, with tiny stickman running way from it.'), nl,
    write('You feel uneasy looking at it...you can go north or go south.').

%white room with painting
describe(white_room) :-
    write('Strangely enough in the middle of cave, you walk into a bright white room that is too clean for comfort.'), nl,
    write('There is nothing of note in the room besides a painting on the north wall, that is of the last supper but with the cast of Family Guy.'), nl,
    write('It\'s intriguing but it doesn\'t help whatsoever, you can go east, go south or go north to inspect painting.').
describe(hidden_ending) :-
    write('Removing the hole in the wall reveals a tunnel with light at the end of it...'), nl,
    write('You enter the tunnel, reaching the end reveals the surface...Congrats! You have escaped with the hidden ending! GAME WON!'), nl, restart, !, fail.

%hermit room
describe(hermit) :-
    write('You see a hermit sitting at a campfire surrounded piles of books, scrolls and gems.'), nl,
    write('He offers you his magic staff for you to take, while suspicously guarding a pile of sticks'), nl,
    write('Do you take the sticks or staff?'), nl,
    write('The only exits are west and south.').

%from shop up
describe(skeleton) :-
    write('You walk into another cavern with a lava pool, the only way is north across a bridge of obsidian.'), nl,
    write('At the start of the bridge, you see a dead minecraft skeleton.'), nl,
    write('There is nothing of note besides his arrows.'), nl,
    write('The only exits are north and south.').
describe(craft_room) :-
    write('You walk into what appears to be a storage room filled with minecraft chests and a crafting table in the middle.'), nl,
    write('You find nothing within the chests, but you feel like you could craft something given the right materials...'), nl,
    write('Perhaps you can try crafting a bow if you have the materials (type `craft(bow).`).'), nl,
    write('The only exits are south, north and an ominous big door to the east.').


%boss description
describe(boss) :-
    write('You walk in and see a giant, evil purple minion.'), nl,
    write('What will you do?'), nl.


%The look empty predicate calls a series of other predicates that will show the room descriptions and any objects
look :- here(Place),
		describe(Place),
		nl,
		show_objects(Place),
		nl.

%The show_objects() predicates are used to show any items that exist in the room outside of the description
show_objects(Place) :-
	item_at(X, Place),
	write('There is a '), write(X), write(' here.'), nl, fail.

show_objects(_).


% The buy/1 predicate allows purchasing items
buy(armor) :-
    here(shop),
    item_at(callOption, in_hand),
    \+ has_armor(true),
    assert(has_armor(true)),
    write('You purchased the armor. You are now protected!'), nl, !.

buy(armor) :-
    here(shop),
    has_armor(true),
    write('You already purchased the armor.'), nl, !.

buy(armor) :-
    here(shop),
    \+ item_at(callOption, in_hand),
    write('You do not have enough poker chips to buy the armor.'), nl, !.

buy(_) :-
    write('You cannot buy that here.'), nl.


% Crafting a bow in the craft room
craft(bow) :-
    here(craft_room),
    item_at(sticks, in_hand),
    item_at(cobweb, in_hand),
    retract(item_at(sticks, in_hand)),
    retract(item_at(cobweb, in_hand)),
    assert(item_at(bow, in_hand)),
    write('You crafted a bow using sticks and cobweb! It is now in your inventory.'), nl, !.

craft(bow) :-
    here(craft_room),
    \+ item_at(sticks, in_hand),
    \+ item_at(cobweb, in_hand),
    write('You don\'t have the required materials to craft a bow. You need sticks and cobweb.'), nl, !.

craft(_) :-
    write('You cannot craft that here.'), nl.


%Predicates used to move to a different room
go(Direction) :-
	here(Curren_Location),
	move_to(Curren_Location, Direction, Next_Location),
	retract(here(Curren_Location)),
	assert(here(Next_Location)), look, !.

go(_) :-
	write('Cannot go there.'), nl.

%Series of shortcut predicates to move in the cardinal directions.
n :- go(n).
s :- go(s).
e :- go(e).
w :- go(w).
u :- go(u).
d :- go(d).

%Help file to show commands
help :- write('------------Help File-------------------'), nl,
		write('|help - Shows the help file'), nl,
		write('|start - starts the game'), nl,
		write('|look - shows the room description of current room'), nl,
		write('|n,s,e,w,u,d - moves in the directions typed'), nl,
		write('|take(X) - allows you to take an item that appears in the room'), nl,
		write('|Make sure you always end your command with a period'), nl,
		write('|halt - end the game.'), nl,
                write('|restart - to restart the game from the beginning.').

start :- write('Welcome to CSCI 4342 Adventure Game'),nl,
		help, nl,nl, look.


