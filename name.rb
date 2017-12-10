require 'bundler'
Bundler.require
require 'open-uri'
require 'URI'

def loadHtml(url, referer)
    charset = nil
    html = open(URI.encode(url), "Referer" => referer) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    return doc
end

def getNames(url, prevUrl)
    names = []
    doc = loadHtml(url, prevUrl)
    doc.xpath('//div[@class="namelist"]').each do |namelist|
        namelist.children.children.each do |tag|
            if tag.name == "tr"
                text = tag.children[5].children.children.children[0]
                if text != nil
                    names << text.inner_text
                end
            end
        end
    end
    return names
end

domain = "http://b-name.jp"
baseUrl = "http://b-name.jp/赤ちゃん名前辞典/m/"
urls = ["http://b-name.jp/赤ちゃん名前辞典/m/あ/", "http://b-name.jp/赤ちゃん名前辞典/m/い/", "http://b-name.jp/赤ちゃん名前辞典/m/う/", "http://b-name.jp/赤ちゃん名前辞典/m/え/", "http://b-name.jp/赤ちゃん名前辞典/m/お/", "http://b-name.jp/赤ちゃん名前辞典/m/か/", "http://b-name.jp/赤ちゃん名前辞典/m/き/", "http://b-name.jp/赤ちゃん名前辞典/m/く/", "http://b-name.jp/赤ちゃん名前辞典/m/け/", "http://b-name.jp/赤ちゃん名前辞典/m/こ/", "http://b-name.jp/赤ちゃん名前辞典/m/さ/", "http://b-name.jp/赤ちゃん名前辞典/m/し/", "http://b-name.jp/赤ちゃん名前辞典/m/す/", "http://b-name.jp/赤ちゃん名前辞典/m/せ/", "http://b-name.jp/赤ちゃん名前辞典/m/そ/", "http://b-name.jp/赤ちゃん名前辞典/m/た/", "http://b-name.jp/赤ちゃん名前辞典/m/ち/", "http://b-name.jp/赤ちゃん名前辞典/m/つ/", "http://b-name.jp/赤ちゃん名前辞典/m/て/", "http://b-name.jp/赤ちゃん名前辞典/m/と/", "http://b-name.jp/赤ちゃん名前辞典/m/な/", "http://b-name.jp/赤ちゃん名前辞典/m/に/", "http://b-name.jp/赤ちゃん名前辞典/m/ぬ/", "http://b-name.jp/赤ちゃん名前辞典/m/ね/", "http://b-name.jp/赤ちゃん名前辞典/m/の/", "http://b-name.jp/赤ちゃん名前辞典/m/は/", "http://b-name.jp/赤ちゃん名前辞典/m/ひ/", "http://b-name.jp/赤ちゃん名前辞典/m/ふ/", "http://b-name.jp/赤ちゃん名前辞典/m/へ/", "http://b-name.jp/赤ちゃん名前辞典/m/ほ/", "http://b-name.jp/赤ちゃん名前辞典/m/ま/", "http://b-name.jp/赤ちゃん名前辞典/m/み/", "http://b-name.jp/赤ちゃん名前辞典/m/む/", "http://b-name.jp/赤ちゃん名前辞典/m/め/", "http://b-name.jp/赤ちゃん名前辞典/m/も/", "http://b-name.jp/赤ちゃん名前辞典/m/や/", "http://b-name.jp/赤ちゃん名前辞典/m/ゆ/", "http://b-name.jp/赤ちゃん名前辞典/m/よ/", "http://b-name.jp/赤ちゃん名前辞典/m/ら/", "http://b-name.jp/赤ちゃん名前辞典/m/り/", "http://b-name.jp/赤ちゃん名前辞典/m/る/", "http://b-name.jp/赤ちゃん名前辞典/m/れ/", "http://b-name.jp/赤ちゃん名前辞典/m/ろ/", "http://b-name.jp/赤ちゃん名前辞典/m/わ/"]
# urls = ["http://b-name.jp/赤ちゃん名前辞典/m/あ/"]

if urls.empty?
    doc = loadHtml(baseUrl, domain)
    doc.xpath('//div[@class="malenamelist_box"]').each do |malenamelist_box|
        malenamelist_box.children.children.children.each do |a|
            urls << domain + a.attribute('href').value
        end
    end
    p urls
end

urls.each do |url|
    # ファイル存在チェック
    initial_character = url.split("/")[5]
    p initial_character
    fileName = "input/" + initial_character + ".txt"
    if File.exist?(fileName)
        next
    end

    names = []
    # 1ページ目
    p "    1 ページ目"
    doc = loadHtml(url, baseUrl)
    doc.xpath('//div[@class="namelist"]').each do |namelist|
        namelist.children.children.each do |tag|
            if tag.name == "tr"
                text = tag.children[5].children.children.children[0]
                if text != nil
                    names << text.inner_text
                end
            end
        end
    end
    prevUrl = url

    # 2ページ目以降
    maxPage = 1
    doc.xpath('//div[@class="numberlink"]').each do |numberlink|
        maxPage = numberlink.children[numberlink.children.size-1].children[0].inner_text.to_i
    end
    pages = 2..maxPage
    pages.each do |page|
        sleep 1
        p "    " + page.to_s + " ページ目 / " + maxPage.to_s + " ページ"
        nextUrl = url + "?p=" + page.to_s
        names << getNames(nextUrl, prevUrl)
        prevUrl = nextUrl
    end

    # ファイル出力
    File.open(fileName, "w"){ |file|
        names.each do |name|
            file.puts name
        end
    }
end
