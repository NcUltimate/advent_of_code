class Program
  class PolymerCounter
    def self.from_polymer(polymer, rules)
      counts = {}

      counts = rules.keys.each_with_object({}) do |key, cts|
        cts[key] ||= 0
      end

      (polymer.length - 1).times do |idx|
        counts[polymer[idx..idx + 1]] += 1
      end

      new(rules, counts)
    end

    attr_reader :rules, :counts
    def initialize(rules, counts = {})
      @rules = rules
      @counts = counts
    end

    def polymerize(steps = 0)
      steps.times.reduce(self) do |counter, _|
        new_counts = counter.counts.each_with_object({}) do |(key, value), nc|
          next if value.zero?

          rules[key].each do |offspring|
            nc[offspring] ||= 0
            nc[offspring] += value
          end
        end
        PolymerCounter.new(rules, new_counts)
      end
    end
  end

  class Polymerizer
    attr_reader :initial_polymer, :known_polymers
    def initialize(initial_polymer, known_polymers)
      @initial_polymer = initial_polymer
      @known_polymers = known_polymers
    end

    def polymerize(steps = 0)
      @polymerizations ||= {}
      @polymerizations[steps] ||= steps.times.reduce(initial_polymer) do |polymer, _|
        Polymer.new(unipolymerize(polymer.polymer))
      end
    end

    private

    def unipolymerize(poly)
      return known_polymers[poly] if known_polymers[poly]

      if poly.length.even?
        m = poly.length / 2 - 1
        left = unipolymerize(poly[0..m])
        right = unipolymerize(poly[m + 1..-1])
        mid = unipolymerize(poly[m..m + 1])
        known_polymers[poly] = left[0...-1] + mid[0...-1] + right
      else
        m = poly.length / 2
        left = unipolymerize(poly[0..m])
        right = unipolymerize(poly[m..-1])
        known_polymers[poly] = left[0...-1] + right
      end
    end
  end

  class Polymer
    attr_reader :polymer
    def initialize(polymer)
      @polymer = polymer
    end

    def polymerize(rules)
      Polymer.new(polymerize1(rules))
    end

    def polymerize1(rules)
      insertions = []
      (polymer.length - 1).times do |idx|
        substr = polymer[idx..(idx + 1)]
        insertions << [idx + 1, rules[substr]] if rules[substr]
      end

      new_polymer = polymer.dup
      insertions.reverse.each do |idx, char|
        new_polymer.insert(idx, char)
      end

      new_polymer
    end

    def polymerize2(rules, poly = polymer, d = 0)
      if poly.size == 2
        if rules[poly]
          return "#{poly[0]}#{rules[poly]}#{poly[1]}"
        else
          return poly
        end
      else
        if poly.length.even?
          m = poly.length / 2 - 1
          left = polymerize2(rules, poly[0..m], d + 1)
          right = polymerize2(rules, poly[m + 1..-1], d + 1)
          mid = polymerize2(rules, poly[m..m + 1], d + 1)
          return left[0...-1] + mid[0...-1] + right
        else
          m = poly.length / 2
          left = polymerize2(rules, poly[0..m], d + 1)
          right = polymerize2(rules, poly[m..-1], d + 1)
          return left[0...-1] + right
        end
      end
    end

    def polymerize3(rules, poly = polymer, d = 0)
      if poly.size == 2
        if rules[poly]
          return "#{poly[0]}#{rules[poly]}#{poly[1]}"
        else
          return poly
        end
      else
        if poly.length.even?
          m = poly.length / 2 - 1
          left = polymerize2(rules, poly[0..m], d + 1)
          right = polymerize2(rules, poly[m + 1..-1], d + 1)
          mid = polymerize2(rules, poly[m..m + 1], d + 1)
          return left[0...-1] + mid[0...-1] + right
        else
          m = poly.length / 2
          left = polymerize2(rules, poly[0..m], d + 1)
          right = polymerize2(rules, poly[m..-1], d + 1)
          return left[0...-1] + right
        end
      end
    end

    def histogram
      @histogram ||= polymer.each_char.each_with_object({}) do |letter, hist|
        hist[letter] ||= 0
        hist[letter] += 1
      end
    end

    def eql?(other)
      polymer.eql?(other.polymer)
    end

    def hash
      polymer.hash
    end

    def to_s
      polymer
    end

    alias_method :inspect, :to_s
  end

  class Solver
    attr_reader :polymer, :rules, :steps
    def initialize(filename, steps = 0)
      @steps = (steps || 0).to_i
      @polymer = ''
      @rules = {}

      polymer = true
      File.open(filename, 'r', &:readlines).each do |l|
        if l.chomp.empty?
          polymer = false
        elsif polymer
          @polymer = Polymer.new(l.chomp)
        else
          rule = l.chomp.split(/ -> /)
          @rules[rule[0]] = [
            "#{rule[0][0]}#{rule[1]}",
            "#{rule[1]}#{rule[0][1]}"
          ]
        end
      end
    end

    def polymerization
      @polymerization ||= steps.times.reduce(polymer) do |polymer, _|
        polymer.polymerize(rules)
      end
    end

    def maxmin
      maxmin = polymerization.histogram.each_with_object([nil, nil]) do |(letter, freq), mm|
        mm[0] = freq if mm[0].nil? || freq > mm[0]
        mm[1] = freq if mm[1].nil? || freq < mm[1]
      end
      maxmin.reduce(&:-)
    end
  end
end