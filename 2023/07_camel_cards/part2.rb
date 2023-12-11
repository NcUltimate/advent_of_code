class Card
  class << self
    def allowed
      @allowed ||= %w[A K Q J T 2 3 4 5 6 7 8 9]
    end

    def all
      @all ||= self.allowed.map(&method(:new))
    end
  end

  attr_reader :card
  def initialize(card)
    @card = card
  end

  def score
    case @card
    when 'A' then 13
    when 'K' then 12
    when 'Q' then 11
    when 'J' then 1
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
    n_of_a_kind?(5) ||
      n_of_a_kind?(4) && joker_count == 1 ||
      n_of_a_kind?(3) && joker_count == 2 ||
      n_of_a_kind?(2) && joker_count == 3 ||
      joker_count >= 4
  end

  def four_of_a_kind?
    n_of_a_kind?(4) ||
      n_of_a_kind?(3) && joker_count == 1 ||
      n_of_a_kind?(2) && joker_count == 2 ||
      joker_count == 3
  end

  def full_house?
    has_three = false
    two_count = 0

    card_counts.each do |card, count|
      if count == 3
        has_three = true
      elsif count == 2
        two_count += 1
      end
    end

    has_three && two_count == 1 ||
      two_count == 2 && joker_count == 1
  end

  def three_of_a_kind?
    n_of_a_kind?(3) ||
      n_of_a_kind?(2) && joker_count == 1 ||
      joker_count == 2
  end

  def two_pair?
    pair_count = card_counts.values.count { |count| count >= 2 }

    if pair_count == 2
      return true
    elsif pair_count == 1
      return joker_count == 1
    end

    joker_count == 2
  end

  def pair?
    n_of_a_kind?(2) || joker_count == 1
  end

  def type
    case score
    when 9 then :five_of_a_kind
    when 8 then :four_of_a_kind
    when 7 then :full_house
    when 6 then :three_of_a_kind
    when 5 then :two_pair
    when 4 then :pair
    else :high_card
    end
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
    card_counts.values.any? { |count| count == n }
  end

  def card_counts
    @card_counts ||= @hand.reduce({}) do |counts, card|
      next counts if card.to_s == 'J'

      counts[card] ||= 0
      counts[card] += 1

      counts
    end
  end

  def joker_count
    @joker_count ||= @hand.count { |card| card.to_s == 'J' }
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
