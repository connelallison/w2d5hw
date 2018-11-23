require("minitest/autorun")
require("minitest/rg")
require_relative("../karaoke.rb")

class KaraokeTest < MiniTest::Test

  def setup()
    @guest_1 = Guest.new("Alfred", 4000, :"Don't Stop Believing")
    @guest_2 = Guest.new("Bob", 2000, :"Land of Hope and Glory")
    @guest_3 = Guest.new("Charles", 1500, :"'Queen of the Night' aria")
    @guest_4 = Guest.new("Daisy", 500, :"Bad Romance")
    @guest_5 = Guest.new("Eric", 1000, :"Living on a Prayer")
    @guest_6 = Guest.new("Frankie", 2500, :"Gimme Gimme Gimme (A Man After Midnight)")
    @guest_7 = Guest.new("Georgina", 0, :"Wrecking Ball")
    @guests_1 = [@guest_1]
    @guests_2 = [@guest_2, @guest_3, @guest_4, @guest_5]
    @guests_3 = [@guest_2, @guest_3, @guest_4, @guest_5, @guest_6]
    @guests_4 = [@guest_7, @guest_3, @guest_4, @guest_5]
    @room_1 = Room.new(1, 5, :"Don't Stop Believing", @guests_1, 2500)
    @room_2 = Room.new(2, 4, :"Gimme Gimme Gimme (A Man After Midnight)", [], 1500)
    @rooms = [@room_1, @room_2]
    @karaoke = Karaoke.new("CodeClan Caraoke", @rooms)
  end

  def test_guest_enters_room_success()
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@guest_6.money, 2500)
    assert_equal(@room_2.money(), 1500)
    assert_equal(@room_2.guest_enters(@guest_6), "Checked in: Frankie.")
    assert_equal(@guest_6.song(@room_2.song), "Hurrah.")
    assert_equal(@room_2.guests.count(), 1)
    assert_equal(@guest_6.money, 2000)
    assert_equal(@room_2.money(), 2000)
  end

  def test_guest_enters_room_too_poor()
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@guest_7.money, 0)
    assert_equal(@room_2.money(), 1500)
    assert_equal(@room_2.guest_enters(@guest_7), "Turned away: Georgina (could not pay fee).")
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@guest_7.money, 0)
    assert_equal(@room_2.money(), 1500)
  end

  def test_party_enters_room_success()
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@room_2.money(), 1500)
    assert_equal(@room_2.party_enters(@guests_2), "Checked in: [\"Bob\", \"Charles\", \"Daisy\", \"Eric\"].")
    assert_equal(@room_2.guests.count(), 4)
    assert_equal(@room_2.money(), 3500)
  end

  def test_party_enters_room_too_full()
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@room_2.money(), 1500)
    assert_equal(@room_2.party_enters(@guests_3), "Turned away: [\"Bob\", \"Charles\", \"Daisy\", \"Eric\", \"Frankie\"] (would exceed room capacity).")
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@room_2.money(), 1500)
  end

  def test_party_enters_room_one_too_poor()
    assert_equal(@guest_3.money, 1500)
    assert_equal(@guest_7.money, 0)
    assert_equal(@room_2.guests.count(), 0)
    assert_equal(@room_2.party_enters(@guests_4), "Checked in: [\"Charles\", \"Daisy\", \"Eric\"]. Turned away: [\"Georgina\"] (could not pay fee).")
    assert_equal(@room_2.guests.count(), 3)
    assert_equal(@guest_3.money, 1000)
    assert_equal(@guest_7.money, 0)
  end

  def test_guest_enters_room_too_full()
    @room_2.party_enters(@guests_2)
    assert_equal(@room_2.guests.count(), 4)
    assert_equal(@room_2.guest_enters(@guest_6), "Turned away: Frankie (would exceed room capacity).")
    assert_equal(@room_2.guests.count(), 4)
  end

  def test_guest_leaves_room()
    assert_equal(@room_1.guests.count(), 1)
    assert_equal(@room_1.guest_leaves(@guest_1), "Checked out: Alfred.")
    assert_equal(@room_1.guests.count(), 0)
  end

  def test_party_leaves_room()
    @room_2.party_enters(@guests_2)
    assert_equal(@room_2.guests.count(), 4)
    assert_equal(@room_2.party_leaves(@guests_2), "Checked out: [\"Bob\", \"Charles\", \"Daisy\", \"Eric\"].")
    assert_equal(@room_2.guests.count(), 0)
  end

  def test_get_karaoke_money()
    assert_equal(@karaoke.money(), 4000)
    @room_2.party_enters(@guests_2)
    assert_equal(@karaoke.money(), 6000)
  end

  def test_change_song()
    @room_2.party_enters(@guests_2)
    assert_equal(@room_2.song(), :"Gimme Gimme Gimme (A Man After Midnight)")
    @room_2.change_song(:"Land of Hope and Glory")
    assert_equal(@guest_2.song(@room_2.song), "Hurrah.")
    assert_equal(@room_2.song(), :"Land of Hope and Glory")
  end

end
