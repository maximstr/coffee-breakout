square = (x) -> x * x

kids =
  brother:
    name: "Max"
    age:  11

$('.account').attr class: 'active'

a = exports ? this

mood = greatlyImproved if singing

awardMedals = (first, second, others...) ->
  gold   = first

awardMedals contenders...

eat food for food in ['toast', 'cheese', 'wine']

menu i + 1, dish for dish, i in courses
# @TODO: test for dish, i, j, in courses

eat food for food in foods when food isnt 'chocolate'

# Comprehension
shortNames = (name for name in list when name.length < 5)

# comprehension with a range
# because the value of comprehension to a variable,
# CS is collecting the result into an array. 
countdown = (num for num in [10..1])

evens = (x for x in [0..10] by 2)

# for key, value in object
ages = for child, age of yearsOld
  "#{child} is #{age}"
# or for own key, value of object (will check hasOwnProperty)

# until == while not
# loop == while true
if !this.studyingEconomics
  buy() while supply > demand

# do
for filename in list
  do (filename) ->
    fs.readFile filename, (err, contents) ->
      compile filename, contents.toString()

# numbers.slice(0, 3);
# ... (0, 4)
# numbers[..] == array copy
start   = numbers[0..2]

alert(
  try
    nonexistent / undefined
  catch error
    "And the error is ... #{error}"
)

###
== into ===
!= into  !==
is into ===
isnt into !==
this.property -> @property
 ** b	Math.pow(a, b)
 a // b	Math.floor(a / b)
 a %% b	(a % b + b) % b
###

# if ((typeof mind !== "undefined" && mind !== null) && ...
solipsism = true if mind? and not world?

# if (speed == null) speed = 15;
speed ?= 15

# typeof yeti !== "undefined" && yeti !== null ? yeti
footprints = yeti ? "bear"

zip = lottery.drawWinner?().address?.zipcode

###
Classes
###
class Animal
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."

class Snake extends Animal
  move: ->
    alert "Slithering..."
    super 5

sam = new Snake "Sammy the Python"
sam.move()

# 1=2 2=1 (Destructuring assignment ???????????????)
[theBait, theSwitch] = [theSwitch, theBait]
[city, temp, forecast] = weatherReport "Berkeley, CA"
{poet: {name, address: [street, city]}} = futurists

class Person
  constructor: (options) -> 
    {@name, @age, @height} = options
tim = new Person age: 4

$('.shopping_cart').bind 'click', (event) =>
    @customer.purchase @cart

#switch
switch day
  when "Mon" then go work
  when "Fri", "Sat"
      go dancing
  else go work

score = 76
grade = switch
  when score < 60 then 'F'
  else 'A'

#
healthy = 200 > cholesterol > 60

#
sentence = "#{ 22 / 7 } is a decent approximation of π"

# if ("" == null)
alert("This is not called") unless ""?


































































