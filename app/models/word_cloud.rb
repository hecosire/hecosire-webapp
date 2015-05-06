class WordCloud

  attr_reader :comments

  def initialize(comments)
    @comments = comments
  end

  def generate
    words = @comments.map{ |c| c.split(" ")}.flatten
    words = words.map { |w| w.downcase.gsub(/[^0-9a-z ]/i, '') }
    wordcloud = Hash.new(0)
    words.each { |word| wordcloud[word] += 1 }
    #@wordcloud.reject!{ |k,v| v == 1 }
    wordcloud.reject!{ |k,v| k.size < 3 }
    wordcloud
  end

end