class Guest
  attr_reader :name, :money, :favourite_song
  def initialize(name, money, favourite_song)
    @name = name
    @money = money
    @favourite_song = favourite_song
  end

  def pay(amount)
    @money -= amount
  end

  def song(song)
    if (song == @favourite_song)
      return "Hurrah."
    end
  end

end

class Room
  attr_reader :room_number, :capacity, :song, :guests, :money, :fee
  def initialize(room_number, capacity, song, guests, money)
    @room_number = room_number
    @capacity = capacity
    @song = song
    @guests = guests
    @money = money
    @fee = 500
  end

  def guest_enters(guest)
    if (@guests.count() < @capacity)
      if (guest.money() >= @fee)
        @guests.push(guest)
        guest.pay(@fee)
        @money += @fee
        guest.song(@song)
        return "Checked in: #{guest.name()}."
      else
        return "Turned away: #{guest.name()} (could not pay fee)."
      end
    else
      return "Turned away: #{guest.name()} (would exceed room capacity)."
    end
  end

  def party_enters(party)
    rejected = []
    accepted = []
    if ((@guests.count() + party.count()) <= @capacity)
      party.each() { |guest|
        if (guest.money() >= @fee)
          @guests.push(guest)
          guest.pay(@fee)
          @money += @fee
          accepted.push(guest.name())
        else
          rejected.push(guest.name())
        end }
    else
      party.each() { |guest| rejected.push(guest.name()) }
      return "Turned away: #{rejected} (would exceed room capacity)."
    end
    if (rejected.count() > 0 && accepted.count() > 0)
      return "Checked in: #{accepted}. Turned away: #{rejected} (could not pay fee)."
    elsif (rejected.count() > 0 && accepted.count() == 0)
      return "Turned away: #{rejected} (could not pay fee)."
    elsif (rejected.count() == 0 && accepted.count() > 0)
      return "Checked in: #{accepted}."
    end
  end

  def guest_leaves(guest)
    @guests.delete(guest)
    return "Checked out: #{guest.name()}."
  end

  def party_leaves(party)
    left = []
    party.each() { |guest|
      @guests.delete(guest)
      left.push(guest.name())
    }
    return "Checked out: #{left}."
  end

  def change_song(song)
    @song = song
    @guests.each() { |guest| guest.song(song) }
  end

end

  class Karaoke
    attr_reader :name, :rooms
    def initialize(name, rooms)
      @name = name
      @rooms = rooms
    end

    def money()
      return @rooms.sum() { |room| room.money }
    end

  end
