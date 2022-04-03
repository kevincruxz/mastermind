def generate_random
    cipher = []
    4.times do 
        random_num = (rand(6) + 1).to_s
        cipher.push(random_num)
    end
    cipher
end

def game
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
        end
        i += 1
    end
end

def ask_cipher
    cipher = 0
    is_okay = false
    while true
        print "Write your guess (4 digits 1-6): "
        cipher = gets.chomp.to_i
        if cipher >= 1111 && cipher <= 6666 # need a better check of digits!
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
                    comp_cipher_copy.delete_at(i - j)
                    break
                end
            end
        end
    end
    str
end

game()