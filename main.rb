def generate_random
    cipher = []
    4.times do 
        random_num = rand(1..6).to_s
        cipher.push(random_num)
    end
    cipher
end

def guesser_game
    i = 1 #Count for the number of trys
    computer_cipher = generate_random()
    12.times do
        if i == 12
            puts "CAREFUL, This is your last chance!"
        end
        puts "TRY ##{i}"
        user_cipher = ask_cipher()
        coincidences = check_equals(user_cipher, computer_cipher)
        if coincidences == "equals"
            puts "Congratulations you guessed it! 🌑🌑🌑🌑"
            puts "The cipher was: #{computer_cipher}"
            again?()
            break
        elsif coincidences == ""
            puts "Wut? there was no coincidences, try another one."
        else
            str = ""
            user_cipher.each do |digit|
                str += " [#{digit}] "
            end
            puts str + " #{coincidences}"
        end
        if i == 12
            puts "Oh man, you lost :( The cipher was: #{computer_cipher}"
            again?()
        end
        i += 1
    end
end

def maker_game
    i = 1
    cipher = ask_cipher() # The user makes it's code
    cipher = cipher.map {|digit| digit.to_i}
    p cipher
    initial_num = rand(1..6)
    try = Array.new(4, initial_num)
    12.times do # Vamos a estar cambiando entre el chack para sacar el response y el algoritmo que responda a esa response
        puts "Computer Try ##{i}"
        response = check_equals(try, cipher)
        if response == 'equals'
            puts "#{try} 🌑🌑🌑🌑"
            puts 'You lose :( The computer guessed your code.'
            again?()
            break
        else
            puts "#{try} #{response}"
            try = make_try(try, response)
        end

        if i == 12
            puts "You Win gg."
            again?()
            break
        end
        print "Press enter to continue."
        gets
        i += 1
    end
end

def again?
    print "Want to play again? (y/n): "
    again = gets.chomp
    mode_selector() if again == "y" || again.downcase == "yes"
end

def make_try(digits, response)
    response = response.split("")
    in_position = 0
    in_array = 0
    response.each do |hint|
        if hint == "🌑"
            in_position += 1
        elsif hint == "🌕"
            in_array += 1
        end
    end 

    if in_position == 0 && in_array == 0
        try = increase_digits(4, digits)
    elsif in_position + in_array == 4
        try = change_order(digits, in_position)
    else
        try = increase_digits((4 - (in_array + in_position)), digits)
    end
    try
end

def increase_digits(how_many, digits)
    i = 3
    while i >= 4 - how_many
        if digits[i] == 6
            digits[i] = 1
        else
            digits[i] += 1
        end
        i -= 1
    end
    digits
end

def change_order(digits, in_position)
    # choose a rand index and from there push, the other digits n times (n = unposicioned digits)
    if in_position == 0
        holder = digits[0]
        digits[0] = digits[3]
        holder_2 = digits[1]
        digits[1] = holder
        holder = digits[2]
        digits[2] = holder_2
        digits[3] = holder

    elsif in_position == 1 
        digit_1 = rand(0..3)
        digit_2 = rand(0..3)
        digit_3 = rand(0..3)
        while digit_2 == digit_1
            digit_2 = rand(0..3)
        end
        while digit_3 == digit_1 || digit_3 == digit_2
            digit_3 = rand(0..3)
        end
        holder = digits[digit_1]
        digits[digit_1] = digits[digit_2]
        digits[digit_2] = holder
        holder = digits[digit_2]
        digits[digit_2] = digits[digit_3]
        digits[digit_3] = holder

    else # 2 in correct position
        digit_1 = rand(0..3)
        digit_2 = rand(0..3)
        while digit_2 == digit_1 || digits[digit_1] == digits[digit_2]
            digit_2 = rand(0..3)
        end
        holder = digits[digit_1]
        digits[digit_1] = digits[digit_2]
        digits[digit_2] = holder
    end
    digits
end

def ask_cipher
    cipher = 0
    is_okay = false
    while true
        print "Write a 4 digits number (only digits from 1 to 6): "
        cipher = gets.chomp.to_i
        if cipher >= 1111 && cipher <= 6666
            cipher_array = cipher.to_s.split("")
            cipher_array.each_with_index do |digit, i|
                if digit.to_i < 1 || digit.to_i > 6
                    puts "Wrong input. Try again"
                    break
                end
                if i == 3
                    is_okay = true
                end
            end
            break if is_okay
        else
            puts "Wrong input. Try again"
        end 
    end
    cipher_array
end

def check_equals(user_cipher, computer_cipher)
    return "equals" if user_cipher == computer_cipher
    comp_cipher = Array.new(computer_cipher)
    user_cipher_copy = Array.new(user_cipher) # These are used in a prosses later
    comp_cipher_copy = Array.new(comp_cipher) # These are used in a prosses later
    str = ""
    j = 0
    # Check what numbers are in exact position
    user_cipher.each_with_index do |digit, i|
        if digit == comp_cipher[i]
            str += "🌑"
            user_cipher_copy.delete_at(i - j)
            comp_cipher_copy.delete_at(i - j)
            j += 1
        end
    end

    # Check what numbers are in the cipher but not in position
    user_cipher_copy.each do |digit|
        if comp_cipher_copy.any?(digit)
            str += "🌕"
            comp_cipher_copy.each_with_index do |digit_, i|
                if digit == digit_
                    comp_cipher_copy.delete_at(i)
                    break
                end
            end
        end
    end
    str
end

def game_start
    str = "Hello! Welcome to Mastermind\n"
    str += "This is a game of guessing codes of colors or (in this case) numbers.\n\n"
    str += "You can choose 2 different gamemodes, code guesser or code maker.\n\n"
    str += "In code gusser mode, you have 12 attemps to guess a random code generated from the computer.\n"
    str += "Each time you enter a 4 digit code, the computer checks for compatibilities and returns to you some hints:\n"
    str += "HINTS INSTRUCTION:\n\"🌑\" means a number is in the code AND in the correct position.\n"
    str += "\"🌕\" means a number is in the code but NOT in the right position.\nIt won't nessesarily return the hints in order.\n"
    str += "\nNow, in the code maker mode, you have to enter whatever code you want and the computer is going to try to guess it.\n"
    str += "\nAnd that's it.\n\n"
    puts str
    mode_selector()
end

def mode_selector
    print "Choose what mode you want to play (type 1 for guesser, 2 for code maker): "
    selection = gets.chomp.to_i
    while selection < 1 || selection > 2
        puts "Wrong input."
        print "Choose what mode you want to play (type 1 for guesser, 2 for code maker): "
        selection = gets.chomp.to_i
    end
    if selection == 1
        guesser_game()
    else
        maker_game()
    end
end

game_start()