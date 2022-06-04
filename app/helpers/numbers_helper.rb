class NumbersHelper
    def self.get_number(id)
        return $redis.incr(id)
    end

    def self.delete_key(id)
        return $redis.del(id)
    end
end