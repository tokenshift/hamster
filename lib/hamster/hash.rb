module Hamster

  class Hash

    def self.[](pairs = {})
      pairs.reduce(self.new) { |hash, pair| hash.put(pair.first, pair.last) }
    end

    def initialize(trie = Trie.new)
      @trie = trie
    end

    def size
      @trie.size
    end

    def empty?
      @trie.empty?
    end

    def has_key?(key)
      @trie.has_key?(key)
    end

    def get(key)
      entry = @trie.get(key)
      if entry
        entry.value
      end
    end
    alias :[] :get

    def put(key, value)
      self.class.new(@trie.put(key, value))
    end

    def remove(key)
      trie = @trie.remove(key)
      if !trie.equal?(@trie)
        self.class.new(trie)
      else
        self
      end
    end

    def each
      block_given? or return enum_for(__method__)
      @trie.each { |entry| yield(entry.key, entry.value) }
      self
    end

    def map
      block_given? or return enum_for(:each)
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(*yield(entry.key, entry.value)) })
      end
    end

    def reduce(memo)
      block_given? or return memo
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key, entry.value) }
    end

    def eql?(other)
      other.is_a?(self.class) && @trie.eql?(other.instance_eval{@trie})
    end
    alias :== :eql?

    def dup
      self
    end
    alias :clone :dup

  end

end
