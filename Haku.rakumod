use v6;

# Haku, a toy functional programming language based on Japanese

role Characters {
    token reserved-kanji {
        '開' | '閉' | '長' | '頭' | '尻' | '尾' |
        '或' |
        # '和' | '差' | '積' | '除' |
        # '足' | '引' | '掛' | '割' |
        '後' | '為' | '等' | '若' | '不' |
        '本' | '事' 
        # '見' | '合' | '割' | '書' | '読' 
    }

   
    token kanji {  
        # Using Block hangs
        <:Block('CJK Unified Ideographs') - reserved-kanji >
        # <:Block('CJK Unified Ideographs')>
        # Need at least all Jouyou kanji here 
        # <[一丁七丈三上下不且世丘丙中丸丹主久乏乗乙九乳乾乱了事ニ二互五井亜亡交享京人仁今介仕他付代令以仰仲件任企伏伐休伯伴伸伺似但位低住佐何仏作佳使来例侍供依侮侯侵便係促俊俗保信修俳俵併倉個倍倒候借倣値倫仮偉偏停健側偶傍傑備催伝債傷傾働像僚偽僧価儀億倹儒償優元兄充兆先光克免児入内全両八公六共兵具典兼冊再冒冗冠冬冷准凍凝凡凶出刀刃分切刈刊刑列初判別利到制刷券刺刻則削前剖剛剰副割創劇剤剣力功加劣助努効劾勅勇勉動勘務勝労募勢勤勲励勧勺匁包化北匠匹匿区十千升午半卑卒卓協南博占印危却卵巻卸即厘厚原去参又及友反叔取受口古句叫召可史右司各合吉同名后吏吐向君吟否含呈呉吸吹告周味呼命和咲哀品員哲唆唐唯唱商問啓善喚喜喪喫単嗣嘆器噴嚇厳嘱囚四回因困固圏国囲園円図団土在地坂均坊坑坪垂型埋城域執培基堂堅堤堪報場塊塑塔塗境墓墜増墨堕墳墾壁壇圧塁壊士壮壱寿夏夕外多夜夢大天太夫央失奇奉奏契奔奥奪奨奮女奴好如妃妊妙妥妨妹妻姉始姓委姫姻姿威娘娯娠婆婚婦婿媒嫁嫡嬢子孔字存孝季孤孫学宅宇守安完宗官宙定宜客宣室宮宰害宴家容宿寂寄密富寒察寡寝実寧審写寛寮宝寸寺封射将専尉尊尋対導小少就尺尼尾尿局居届屈屋展層履属山岐岩岸峠峰島峡崇崩岳川州巡巣工左巧巨差己市布帆希帝帥師席帳帯常帽幅幕幣干平年幸幹幻幼幽幾床序底店府度座庫庭庶康庸廉廊廃広庁延廷建弊式弓弔引弟弦弧弱張強弾形彩彫彰影役彼往征待律後徐径徒得従御復循微徴徳徹心必忌忍志忘忙忠快念怒怖思怠急性怪恒恐恥恨恩恭息悦悔悟患悲悼情惑惜恵悪惰悩想愁愉意愚愛感慎慈態慌慕惨慢慣慨慮慰慶憂憎憤憩憲憶憾懇応懲懐懸恋成我戒戦戯戸房所扇手才打扱扶批承技抄抑投抗折抱抵押抽払拍拒拓抜拘拙招拝括拷拾持指振捕捨掃授掌排掘掛採探接控推措描提揚換握掲揮援損揺捜搬携搾摘摩撤撮撲擁択撃操担拠擦挙擬拡摂支収改攻放政故叙教敏救敗敢散敬敵敷数整文斗料斜斤斥新断方施旅旋族旗既日旨早旬昇明易昔星映春昨昭是時晩昼普景晴晶暇暑暖暗暫暮暴暦曇暁曜曲更書替最会月有服朕朗望朝期木未末本札朱机朽材村束杯東松板析林枚果枝枯架柄某染柔査柱柳校株核根格栽桃案桑梅条械棄棋棒森棺植業極栄構概楽楼標枢模様樹橋機横検桜欄権次欲欺款歌欧歓止正歩武歳歴帰死殉殊殖残段殺殿殴母毎毒比毛氏民気水氷永求汗汚江池決汽沈没沖河沸油治沼沿況泉泊泌法波泣注泰泳洋洗津活派流浦浪浮浴海浸消渉液涼淑涙淡浄深混清浅添減渡測港渇湖湯源準温溶滅滋滑滞滴満漁漂漆漏演漢漫漸潔潜潤潮渋澄沢激濁濃湿済濫浜滝瀬湾火灰災炊炎炭烈無焦然煮煙照煩熟熱燃燈焼営燥爆炉争為爵父片版牛牧物牲特犠犬犯状狂狩狭猛猶獄独獲猟獣献玄率玉王珍珠班現球理琴環璽甘生産用田由甲申男町界畑畔留畜畝略番画異当畳疎疑疫疲疾病症痘痛痢痴療癖登発白百的皆皇皮皿盆益盛盗盟尽監盤目盲直相盾省看真眠眼着睡督瞬矛矢知短石砂砲破研硝硫硬碁砕碑確磁礁礎示社祈祉秘祖祝神祥票祭禁禍福禅礼秀私秋科秒租秩移税程稚種称稲稿穀積穂穏穫穴究空突窒窓窮窯窃立並章童端競竹笑笛符第筆等筋筒答策箇算管箱節範築篤簡簿籍米粉粒粗粘粧粋精糖糧系糾紀約紅紋納純紙級紛素紡索紫累細紳紹紺終組結絶絞絡給統糸絹経緑維綱網綿緊緒線締縁編緩緯練縛県縫縮縦総績繁織繕絵繭繰継続繊欠罪置罰署罷羊美群義羽翁翌習翼老考者耐耕耗耳聖聞声職聴粛肉肖肝肥肩肪肯育肺胃背胎胞胴胸能脂脅脈脚脱脹腐腕脳腰腸腹膚膜膨胆臓臣臨自臭至致台与興旧舌舎舗舞舟航般舶船艇艦良色芋芝花芳芽苗若苦英茂茶草荒荷荘茎菊菌菓菜華万落葉著葬蒸蓄薄薦薪薫蔵芸薬藩虐処虚虜虞号蚊融虫蚕蛮血衆行術街衝衛衡衣表衰衷袋被裁裂裏裕補装裸製複襲西要覆見規視親覚覧観角解触言訂計討訓託記訟訪設許訴診詐詔評詞詠試詩詰話該詳誇誌認誓誕誘語誠誤説課調談請論諭諮諸諾謀謁謄謙講謝謡謹証識譜警訳議護誉読変譲谷豆豊豚象豪予貝貞負財貢貧貨販貫責貯弐貴買貸費貿賀賃賄資賊賓賜賞賠賢売賦質頼購贈賛赤赦走赴起超越趣足距跡路跳踊踏践躍身車軌軍軒軟軸較載軽輝輩輪輸轄転辛弁辞辱農込迅迎近返迫迭述迷追退送逃逆透逐途通速造連逮週進逸遂遇遊運遍過道達違逓遠遣適遭遅遵遷選遺避還辺邦邪邸郊郎郡部郭郵都郷配酒酢酬酪酵酷酸酔醜医醸釈里重野量金針鈍鈴鉛銀銃銅銑銘鋭鋼録錘錠銭錯錬鍛鎖鎮鏡鐘鉄鋳鑑鉱長門閉開閑間閣閥閲関防阻附降限陛院陣除陪陰陳陵陶陥陸陽隆隊階隔際障隣随険隠隷隻雄雅集雇雌双雑離難雨雪雲零雷電需震霜霧露霊青静非面革音韻響頂項順預頒領頭題額顔願類顧顕風飛翻食飢飲飯飼飽飾養餓余館首香馬駐騎騰騒駆験驚駅骨髄体高髪闘鬼魂魅魔魚鮮鯨鳥鳴鶏塩麗麦麺麻黄黒黙点党鼓鼻斎歯齢猿凹渦靴稼拐垣殻潟喝褐缶頑挟矯襟隅渓蛍嫌洪溝昆崎桟傘肢遮蛇酌汁塾尚宵縄壌唇甚据杉斉逝仙栓挿曹槽藻駄濯棚挑眺釣塚漬亭偵泥搭棟洞凸屯把覇漠肌鉢披扉猫頻瓶雰塀泡俸褒朴僕堀磨抹岬妄厄癒悠羅竜戻枠媛怨鬱唄淫咽茨彙椅萎畏嵐宛顎曖挨韓鎌葛骸蓋崖諧潰瓦牙苛俺臆岡旺艶稽憬詣熊窟串惧錦僅巾嗅臼畿亀伎玩挫沙痕頃駒傲乞喉梗虎股舷鍵拳桁隙呪腫嫉𠮟叱鹿餌摯恣斬拶刹柵埼塞采戚脊醒凄裾須腎芯尻拭憧蹴羞袖汰遜捉踪痩曽爽遡狙膳箋詮腺煎羨鶴爪椎捗嘲貼酎緻綻旦誰戴堆唾鍋謎梨奈那丼貪頓栃瞳藤賭妬塡填溺諦阜訃肘膝眉斑阪汎氾箸剝剥罵捻虹匂喩闇弥冶冥蜜枕昧勃頰頬貌蜂蔑璧餅蔽脇麓籠弄呂瑠瞭侶慄璃藍辣拉沃瘍妖湧柿哺楷睦釜錮賂毀勾垓𥝱穣澗]>

        }  

    token number-kanji { 
        | '一' | '二' | '三' | '四' | '五' | '六' | '七' | '八' | '九' | '十' 
        | '壱' | '弐' | '参' |                                          '拾'                  
        | '百' | '千' | '万' | '億' 
        |               '萬' 
        | '兆' | '京' | '垓' | '𥝱' | '穣' | '溝' | '澗' | '正' | '載' | '極' 
# See https://www.tofugu.com/japanese/counting-in-japanese/ for <1e-12
        | '分' | '厘' | '毛' | '糸' | '忽' | '微' | '繊' | '沙' | '塵' | '埃' | '渺' | '漠'

        }
    
    token haku-kanji {
        '白' | '泊' | '箔' | '伯' | '拍' | '舶' | 
        '迫' | '岶' | '珀' | '魄' | '柏' | '帛' | '博'
    }

    token katakana { 
        # Using Block hangs
        # <:Block('Katakana')> 
        <[ア..ヺー]>
    }

    # I might allow A-Z as well for identifiers
    token romaji {
        <[A..Z]>
    }    
    # "１".uniprop('Block');
    # Halfwidth and Fullwidth Forms
    # 算用数字
    token sanyousuji {
        '０' | '１' | '２' | '３' | '４' | '５' | '６' | '７' | '８' | '９'
    }
    
    # I might allow ordinary digits in identifier names
    token digits {
        '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' 
    }    

    token hiragana {
        # Using Block hangs
        <:Block('Hiragana')>
        # <[あ..を]>
    }    

    token word {
        \w
    }
}



# I think I will use the full stop and semicolon as equivalent for newline.
role Punctuation {

    token full-stop { '。' }
    token comma { '、' }
    token semicolon { '；' }    
    token colon { '：' }
    token interpunct { '・' } # nakaguro 
    token punctuation { <full-stop> | <comma> | <semicolon> | <colon> }
    token delim { [<full-stop> | <comma> | <semicolon>] <ws>? }

    # ︵	U+FE35	1-1-42 包摂	&#xFE35;
    # &#65077;	始め小括弧、始め丸括弧
    # PRESENTATION FORM FOR VERTICAL LEFT PARENTHESIS
    # ︶	U+FE36	1-1-43 包摂	&#xFE36;
    # &#65078;	終わり小括弧、終わり丸括弧
    # PRESENTATION FORM FOR VERTICAL RIGHT PARENTHESIS

    # Marukakko (丸括弧) 
    token open-maru { '（' }
    token close-maru { '）' }
    # Namikakko (波括弧)
    token open-nami { '｛' }
    token close-nami { '｝' }

    # ﹇	U+FE47	1-1-46 包摂	&#xFE47;
    # &#65095;	始め大括弧、始め角括弧
    # PRESENTATION FORM FOR VERTICAL LEFT SQUARE BRACKET
    # ﹈	U+FE48	1-1-47 包摂	&#xFE48;
    # &#65096;	終わり大括弧、終わり角括弧
    # PRESENTATION FORM FOR VERTICAL RIGHT SQUARE BRACKET

    # Kakukakko (角括弧)
    token open-kaku { '［' }
    token close-kaku { '］' }

    token open-sen { '〈' }
    token close-sen { '〉' }

#  etc, see https://ja.wikipedia.org/wiki/%E6%8B%AC%E5%BC%A7

    # sumitsukikakko (隅付き括弧)
    token open-sumitsuki { '【' }
    token close-sumitsuki { '】' }
}

role Particles {

    token ga { 'が' }
    token ha { 'は' }
    token no { 'の' }
    token to-particle { 'と' }
    token mo { 'も' }
    token wo { 'を' }
    token de { 'で' }
    token ni { 'に' }
    token ka { 'か' }
    token kara { 'から' }
    token made_ {  '迄' | 'まで' }
    token deha { 'では' }
    token node { 'ので' }
    token noha { 'のは' }
    token dake { '丈' | 'だけ' } 

}

role Nouns does Characters {
    token sa { 'さ' }
    token noun { <kanji>+ <sa>? }
}

role Verbs does Characters {
    token verb-ending {
        'る'| 'す'| 'む'| 'く'| 'ぐ'| 'つ'| 'ぬ'|
        'った'| 'た'| 'いだ'| 'んだ'|
        'って'| 'て'| 'いで' | 'んで'
    }
    # token noun { <kanji>+ <sa>? }
    token verb { <kanji> <hiragana>*? <verb-ending> }

}

role Variables does Characters {
    # Variables must start with katakana then katakana, number kanji and 達 
    # But kanji with a "haku" on-reading are also supported.
    token variable { 
        [ <katakana> | <haku-kanji> ]
        [ <katakana>  | <haku-kanji> | <number-kanji> ]* <tachi>? 
    }
    # To indicate plural
    token tachi { '達' }    
}

role Identifiers does Verbs does Nouns does Variables {
    
    # Identifiers are variables noun-style and verb-style function names
    token identifier { <variable> | <verb> | <noun> }

}

role Auxiliaries {
    token kudasai { ['下' | 'くだ' ] 'さい' }
    token masu { 'ます' }

    token shite-kudasai { 'して' [ '下' | 'くだ' ] 'さい' }
    token suru { 'する' | '為る' }
    token shimasu { 'します' }
    token sura {
        <suru> | <shimasu> | <shite-kudasai> 
    }
    token desu { 'です' | 'だ'  | 'である' |　'で或る' |　'でございます' }
}

# +: Tasu (足す)
# -: Hiku (ひく or 引く)
# *: Kakeru (掛ける or かける)
# /: Waru (割る or わる)
# product 積　せき
# sum 和 わ
# division　除 じょ
# difference : 差 さ
# number times <x>: <x> <number> 倍 ばい

role Operators does Characters does Punctuation 
{
#                         +       -      *      /
    token operator-noun { '和' | '差' | '積' | '除' }
    token operator-verb-kanji { '足' | '引' | '掛' | '割' }
    token operator-verb { <operator-verb-kanji> <hiragana>*? <verb-ending> }    
    token list-operator { <to-particle> | <comma>}
    token nochi { '後' | 'のち' } # g . f
    token aru { '或' } # the \ operator
    token cons { <interpunct> | <colon> }
}


role Keywords 
does Operators
does Particles
does Auxiliaries
does Verbs 
does Nouns
# I might split these out further
{
    # For an empty list
    token kuu { '空' }
    # For Nil
    token mu { '無' }

    # For Ranges
    token nyoro { '〜' }

    # For Comparisons 

    token hitoshii { '等しい' }
    token yori { 'より' }
    token ooi { '多い' }    
    token sukunai { '少ない' }
    

    # For Let
    token kono {
        'この'
    }
    # See design doc
    token moshi { 
        [ 'もし' | '若し' ] <mo>?　<ws>?
    }
    token nara { 'なら' }
    token tara { 'たら' }

    token dattara { 'だったら' }
    token moshi-nanira { <dattara> |　<tara> | <nara> }
    
    token kuromaru { '●' }    

    # For IfThenElse

    token kedo { 'けど' | 'けれど' <mo>? }
    token baaiha { '場合は' }
    token soudenai { 'そうでない' }

    # For Maps and Folds

    token nokaku { 'の各' }
    token nominnaga { 'の皆が' }
    token shazou { '写像' <sura> }     
    token tatamu { '畳' <mu-endings> }
    # For Function and Hon

    token toha { 'とは' }

    token toiu { 'という' | 'と言う' }

    token koto { 'こと' | '事' }

    # For Haku

    token hontoha { '本とは' <.ws>? }

    # Built-in verbs
    token u-endings {
        'う' | 'って' <kudasai>? | 'い' <masu>
    }
    token mu-endings {
        'む' | 'んで' <kudasai>? | 'み' <masu>
    }

    token ru-endings {
         'る' | 'て' <kudasai>? | 'り' <masu>
    }

    token ku-endings {
         'く' | 'いて' <kudasai>? | 'き' <masu>
    }

    token tsu-endings {
         'つ' | 'って' <kudasai>? | 'ち' <masu>
    }

    # Say
    token miseru { '見せ' <ru-endings> }

    # Built-in nouns

    # List operations; strings are lists.
    token nagasa { '長さ' }

    token atama { '頭' }
    token shippo  { '尻尾' }
    
    token awaseru { '合わせ' <ru-endings> }
    token waru { '割' <ru-endings> }

    # File operations
    token akeru { '開け' <ru-endings> }
    token shimeru { '閉め' <ru-endings> }
    token kaku { '書' <ku-endings> }
    token yomu { '読' <mu-endings> }

    # For comparisons
    token chigau { '違' <u-endings> }
} # End of Keywords

# Comment line: 註 or 注 or even just 言, must end with 。
role Blanks {
    token blank {  '　' | ' ' | \n | \t }
}
role Comments does Punctuation does Blanks {
    token comment-start { '註' | '注' | '言' }
    token comment-chars { 
         <hiragana> | <katakana> | <kanji> | <word> | <blank>
    }
    token comment { <.comment-start> <comment-chars>+ <.full-stop> <.ws>? }
}

role Numbers does  Characters {
# role Constants does Characters {    
    token zero { '〇' | '零' | 'ゼロ' | 'マル'  }
    token minus {'マイナス'}
    token plus {'プラス'}
    token integer { [<number-kanji> | <zero>]+ }
    token signed-integer { (<minus> | <plus>) <integer> }
    token ten { '点' }
    token rational { <signed-integer>+ <.ten> <integer>+ }
    token number { 
        <rational> | <signed-integer> | <integer> 
    }
}

role Strings does Characters {
    token string-chars { 
         <hiragana> 
         | <katakana>
          | <kanji> | <word> | ' ' | '　' | \n
        #   | <blank> 
    }
    token string { 
        [ '「' <string-chars>* '」' ] |
        [ '『'  <string-chars>* '』' ] |
        [ '《'  <string_chars>* '》' ]
    }
}

# role Constants does Numbers does Strings {
#     token constant {
#         <number> | <string>
#     }
# }
grammar Expression 
does Identifiers 
# does Variables
does Keywords 
does Numbers
does Strings
does Comments 
{

    token TOP { <expression> }
 
    token atomic-expression {  <number> | <string> | <mu> | <kuu> | <identifier>   }
    token parens-expression { 
        [ <.open-maru> <expression> <.close-maru> ] |
        [ <.open-sumitsuki> <expression> <.close-sumitsuki> ] |
        [ <.open-sen> <expression> <.close-sen> ] 
    }
    token kaku-parens-expression { <.open-kaku> [<list-expression> | <range-expression>] <.close-kaku> }

    token verb-operator-expression { <arg-expression> <.ni>　<arg-expression> <.wo> <operator-verb> }
    token verb-operator-expression-infix { <arg-expression> <operator-verb> <arg-expression> }
    token noun-operator-expression { <arg-expression> <.to-particle>　<arg-expression> <.no> <operator-noun> }

    token operator-expression { 
        <noun-operator-expression> | 
        <verb-operator-expression> | 
        <verb-operator-expression-infix> 
    }
    
    token list-expression { <atomic-expression> [ <.list-operator> <atomic-expression> ]* }
    token arg-expression-list {
        <arg-expression> [<.list-operator> <arg-expression>]*
    }

    # Keeping it simple: everything needs parens
    token arg-expression {
        <parens-expression> |
        # <apply-expression> | # LOOP, needs parens
        # <lambda-expression> | 
        # <range-expression> |        
        <atomic-expression>         
    }
    token empty {
        <open-kaku><close-kaku>
    }
    token cons-list-expression { <variable> [ <.cons> [<variable>|<kuu>|<empty>]]* } #? [<.cons> [<kuu>|<empty>] ]? }
    
    token variable-list { <variable> [ <.list-operator> <variable> ]* }

    # I need to distinguish between verb expressions and noun expressions
    # suppose I have x de x to x no seki , then it is shite (kudasai)
    # suppose I have x de x ni x wo kakeru , then it should really be x de x ni x wo kakete (kudasai)
    
    token lambda-expression { <.aru> <variable-list> <.de> <expression> }
    # token lambda-application { <expression> 'を'　 [ <shite-kudasai> | <te-kudasai> | <sura> ]? }
    token apply-expression {<arg-expression-list> <dake>? [ <.wo> | <.no> ]　
    [ <identifier> | <lambda-expression> ] 
        [<.shite-kudasai>|<.sura>]? }

    token comment-then-expression {
        <comment>+ <expression>
    }
    token expression {                     
        [  <lambda-expression>         
        | <let-expression>  
        | <apply-expression> 
        | <operator-expression>
        | <comparison-expression>
        | <function-comp-expression>
        ] || 
        [ <parens-expression>  
        | <range-expression>
        | <list-expression>
        | <cons-list-expression>        
        | <atomic-expression>              
        | <comment-then-expression>
        ]
    }

    token function-comp-expression {
        <identifier> [<nochi> <identifier>]+
    }
    token range-expression {
        <atomic-expression> <.nyoro> <atomic-expression>
    }


    token comparison-expression {
        <arg-expression> <.ga> <arg-expression> 
        [
          [
            [ <.ni> <hitoshii> [ <.ka> <.yori> [ <sukunai> | <ooi> ] ]? ]        
            | [ <.yori> [ <sukunai> | <ooi> ]  ]  
            <.desu>?
          ]
        | [ <.ni> <chigau> ]
        ]
    }

    token bind-ha { [ <variable> | <cons-list-expression>] <.ha> <expression> [<.desu> | <.de> ]? <.delim> }
    token bind-ga { [ <variable> | <cons-list-expression>] <.ga> <expression> [<.desu> | <.de> ]? <.ws>? }
    token bind-tara { [ <variable> | <cons-list-expression>] <.ga> <expression> <.moshi-nanira> <.ws>? }
    # token moshi-let {
    #     <moshi> <bind-tara>+  <expression>  <delim>?
    # }
    
    token kono-let {
        <.kono>  <.ws>? <expression> <.ni> <.ws>? <bind-ga> [<.delim> <.ws>? <bind-ga>]* <.delim>?
    }
    token kuromaru-let {
         [ <kuromaru> <bind-ha> ]+ <.deha> <.ws>? <expression> <delim>?
    }

    token let-expression { <kuromaru-let> | <kono-let> }

    # IfThen 
    token condition-expression {
        <operator-expression> |
        <comparison-expression> |
        <apply-expression> |   
        <parens-expression> |
        <atomic-expression>
    }

    token baai-ifthen {
        <condition-expression> <.baaiha>   <expression> [<.desu> [<.ga> | <.kedo> ]]? <.comma>? <.ws>?
        <.soudenai> <.baaiha> <.comma>? <.ws>? <expression>
    }
    token moshi-ifthen {
        <.moshi>
        <condition-expression>  <.nara> <expression> [<.desu> [<.ga> | <.kedo> ]]? <.comma>? <.ws>?
        <.soudenai> <.comma>? <.ws>?　<expression> <.desu>?
    }

    token ifthen {
        <moshi-ifthen> |
        <baai-ifthen> 
    }

    # Map
    token map-expression {
        [ <variable> | <list-expression> | <range-expression> ] 
        [ <.nokaku> <lambda-expression> 
        |
        <.nominnaga>　[ <identifier> | <comp-expression> ] 
        ]
        <.wo> <.shazou> 
    }

    # Fold
    token fold-expression {
        [ <variable> | <list-expression> | <range-expression> ] 
        <.nominnaga>
        [ <operator-noun> | <identifier> | <verb> <.no> ] <.wo> <expression> <.to-particle> <.tatamu> 
    }

} # End of Expression

grammar Functions is Expression does Keywords does Punctuation { 
    
    token TOP { <function> }
    token function {
        [ <verb> | <noun> ] <.toha>
        <variable-list> <.de> <.ws>? <expression> <.function-end>
        # [<let-expression> | <expression>]
    }

    token function-end {
         <.ws>? [<no>|<toiu>]? <koto> <desu> <full-stop> <.ws>?
    }
}


grammar Haku is Functions does Comments does Keywords {
    token TOP { <haku-program> }
    token haku-program {
        # <comment>
        [<function>| <comment>]*? 
        <hon>
        # [<function>| <comment>]*?
    }

    # Behaves like an 'do' but without the monads
    token hon { 
        　<.hontoha> 
          [ 
              <bind-ha> |
              [<expression> <.delim>] |     
            <comment>
          ]*?
          <expression> <.delim>?
        <.function-end>                 
    }

}
