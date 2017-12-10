require 'bundler'
Bundler.require

fileNames = ["input/あ.txt", "input/い.txt", "input/う.txt", "input/え.txt", "input/お.txt", "input/か.txt", "input/き.txt", "input/く.txt", "input/け.txt", "input/こ.txt", "input/さ.txt", "input/し.txt", "input/す.txt", "input/せ.txt", "input/そ.txt", "input/た.txt", "input/ち.txt", "input/つ.txt", "input/て.txt", "input/と.txt", "input/な.txt", "input/に.txt", "input/ぬ.txt", "input/ね.txt", "input/の.txt", "input/は.txt", "input/ひ.txt", "input/ふ.txt", "input/へ.txt", "input/ほ.txt", "input/ま.txt", "input/み.txt", "input/む.txt", "input/め.txt", "input/も.txt", "input/や.txt", "input/ゆ.txt", "input/よ.txt", "input/ら.txt", "input/り.txt", "input/る.txt", "input/れ.txt", "input/ろ.txt", "input/わ.txt"]

allNames = []
fileNames.each do |fileName|
    names = []
    File.open(fileName, "r"){ |file|
        names = file.readlines
        names.map! { |name| name.strip! }.uniq!
        allNames += names
    }
end

File.open("output/allNmaes.txt", "w"){ |file|
    allNames.each do |name|
        file.puts name
    end
}

File.open("output/name3.txt", "w"){ |file|
    allNames.select { |name|
        name =~ /\A[^ゃゅょ]{3}\z/ ||
        name =~ /\A[あ-ん]([あ-ん][ゃゅょ]|[ゃゅょ][あ-ん])[あ-ん]\z/
    }.each do |name|
        p name
        file.puts name
    end
}