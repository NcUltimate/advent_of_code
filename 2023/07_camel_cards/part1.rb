class Card
  def initialize(card)
    @card = card
  end

  def score
    case @card
    when 'A' then 14
    when 'K' then 13
    when 'Q' then 12
    when 'J' then 11
    when 'T' then 10
    else @card.to_i
    end
  end

  def hash
    @card.hash
  end

  def eql?(other)
    hash == other.hash
  end

  def to_s
    @card.to_s
  end

  def inspect
    to_s
  end
end

class Hand
  attr_reader :hand

  def initialize(hand)
    @hand = hand.split('').map(&Card.method(:new))
  end

  def five_of_a_kind?
    n_of_a_kind?(5)
  end

  def four_of_a_kind?
    n_of_a_kind?(4)
  end

  def full_house?
    @hand.uniq.length == 2 && three_of_a_kind?
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_pair?
    @hand.uniq.length == 3 && pair?
  end

  def pair?
    n_of_a_kind?(2)
  end

  def type
    return :five_of_a_kind if five_of_a_kind?
    return :four_of_a_kind if four_of_a_kind?
    return :full_house if full_house?
    return :three_of_a_kind if three_of_a_kind?
    return :two_pair if two_pair?
    return :pair if pair?

    :high_card
  end

  def score
    return 9 if five_of_a_kind?
    return 8 if four_of_a_kind?
    return 7 if full_house?
    return 6 if three_of_a_kind?
    return 5 if two_pair?
    return 4 if pair?

    1
  end

  def <=>(other)
    if score != other.score
      return score <=> other.score
    end
  
    @hand.each_index do |idx|
      if !@hand[idx].eql?(other.hand[idx])
        return @hand[idx].score <=> other.hand[idx].score
      end 
    end

    0
  end

  def to_s
    @hand.join
  end

  def inspect
    to_s
  end

  private

  def n_of_a_kind?(n)
    @hand.group_by(&:itself).values.any? { |v| v.size == n }
  end
end

class Game
  attr_reader :hands

  def initialize(game)
    @hands = game.map do |line|
      hand, bid = line.split(' ')
      [Hand.new(hand), bid.to_i]
    end

    @hands.sort! do |a, b|
      a[0] <=> b[0]
    end
  end

  def total
    @hands.each_index.sum(0) do |idx|
      @hands[idx][1] * (idx + 1)
    end
  end
end

game = Game.new(File.open(ARGV[0], 'r', &:readlines))

puts game.total
