class NumbersHelper
    def self.get_number(id)
        return $redis.incr(id)
    end
end