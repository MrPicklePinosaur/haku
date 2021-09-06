use v6;

role Characters {
    token reserved-kanji {
        #'開' | '閉' | '長' | '頭' | '尻' | '尾' |
        '或' |
        # '和' | '差' | '積' | '除' |
        # '足' | '引' | '掛' | '割' |
        '後' | '為' | '等' | '若' | '不' |
        '本' | '事' | 
        '皆' | '空' |
        # '見' | '合' | '割' | '読' 
    }

   
    token kanji {  
        # Using Block hangs
#<:Block('CJK Unified Ideographs') - reserved-kanji >
        # <:Block('CJK Unified Ideographs')>
        # Need at least all Jouyou kanji here 
        <[一丁七丈三上下不且世丘丙中丸丹主久乏乗乙九乳乾乱了事ニ二互五井亜亡交享京人仁今介仕他付代令以仰仲件任企伏伐休伯伴伸伺似但位低住佐何仏作佳使来例侍供依侮侯侵便係促俊俗保信修俳俵併倉個倍倒候借倣値倫仮偉偏停健側偶傍傑備催伝債傷傾働像僚偽僧価儀億倹儒償優元兄充兆先光克免児入内全両八公六共兵具典兼冊再冒冗冠冬冷准凍凝凡凶出刀刃分切刈刊刑列初判別利到制刷券刺刻則削前剖剛剰副割創劇剤剣力功加劣助努効劾勅勇勉動勘務勝労募勢勤勲励勧勺匁包化北匠匹匿区十千升午半卑卒卓協南博占印危却卵巻卸即厘厚原去参又及友反叔取受口古句叫召可史右司各合吉同名后吏吐向君吟否含呈呉吸吹告周味呼命和咲哀品員哲唆唐唯唱商問啓善喚喜喪喫単嗣嘆器噴嚇厳嘱囚四回因困固圏国囲園円図団土在地坂均坊坑坪垂型埋城域執培基堂堅堤堪報場塊塑塔塗境墓墜増墨堕墳墾壁壇圧塁壊士壮壱寿夏夕外多夜夢大天太夫央失奇奉奏契奔奥奪奨奮女奴好如妃妊妙妥妨妹妻姉始姓委姫姻姿威娘娯娠婆婚婦婿媒嫁嫡嬢子孔字存孝季孤孫学宅宇守安完宗官宙定宜客宣室宮宰害宴家容宿寂寄密富寒察寡寝実寧審写寛寮宝寸寺封射将専尉尊尋対導小少就尺尼尾尿局居届屈屋展層履属山岐岩岸峠峰島峡崇崩岳川州巡巣工左巧巨差己市布帆希帝帥師席帳帯常帽幅幕幣干平年幸幹幻幼幽幾床序底店府度座庫庭庶康庸廉廊廃広庁延廷建弊式弓弔引弟弦弧弱張強弾形彩彫彰影役彼往征待律後徐径徒得従御復循微徴徳徹心必忌忍志忘忙忠快念怒怖思怠急性怪恒恐恥恨恩恭息悦悔悟患悲悼情惑惜恵悪惰悩想愁愉意愚愛感慎慈態慌慕惨慢慣慨慮慰慶憂憎憤憩憲憶憾懇応懲懐懸恋成我戒戦戯戸房所扇手才打扱扶批承技抄抑投抗折抱抵押抽払拍拒拓抜拘拙招拝括拷拾持指振捕捨掃授掌排掘掛採探接控推措描提揚換握掲揮援損揺捜搬携搾摘摩撤撮撲擁択撃操担拠擦挙擬拡摂支収改攻放政故叙教敏救敗敢散敬敵敷数整文斗料斜斤斥新断方施旅旋族旗既日旨早旬昇明易昔星映春昨昭是時晩昼普景晴晶暇暑暖暗暫暮暴暦曇暁曜曲更書替最会月有服朕朗望朝期木未末本札朱机朽材村束杯東松板析林枚果枝枯架柄某染柔査柱柳校株核根格栽桃案桑梅条械棄棋棒森棺植業極栄構概楽楼標枢模様樹橋機横検桜欄権次欲欺款歌欧歓止正歩武歳歴帰死殉殊殖残段殺殿殴母毎毒比毛氏民気水氷永求汗汚江池決汽沈没沖河沸油治沼沿況泉泊泌法波泣注泰泳洋洗津活派流浦浪浮浴海浸消渉液涼淑涙淡浄深混清浅添減渡測港渇湖湯源準温溶滅滋滑滞滴満漁漂漆漏演漢漫漸潔潜潤潮渋澄沢激濁濃湿済濫浜滝瀬湾火灰災炊炎炭烈無焦然煮煙照煩熟熱燃燈焼営燥爆炉争為爵父片版牛牧物牲特犠犬犯状狂狩狭猛猶獄独獲猟獣献玄率玉王珍珠班現球理琴環璽甘生産用田由甲申男町界畑畔留畜畝略番画異当畳疎疑疫疲疾病症痘痛痢痴療癖登発白百的皆皇皮皿盆益盛盗盟尽監盤目盲直相盾省看真眠眼着睡督瞬矛矢知短石砂砲破研硝硫硬碁砕碑確磁礁礎示社祈祉秘祖祝神祥票祭禁禍福禅礼秀私秋科秒租秩移税程稚種称稲稿穀積穂穏穫穴究空突窒窓窮窯窃立並章童端競竹笑笛符第筆等筋筒答策箇算管箱節範築篤簡簿籍米粉粒粗粘粧粋精糖糧系糾紀約紅紋納純紙級紛素紡索紫累細紳紹紺終組結絶絞絡給統糸絹経緑維綱網綿緊緒線締縁編緩緯練縛県縫縮縦総績繁織繕絵繭繰継続繊欠罪置罰署罷羊美群義羽翁翌習翼老考者耐耕耗耳聖聞声職聴粛肉肖肝肥肩肪肯育肺胃背胎胞胴胸能脂脅脈脚脱脹腐腕脳腰腸腹膚膜膨胆臓臣臨自臭至致台与興旧舌舎舗舞舟航般舶船艇艦良色芋芝花芳芽苗若苦英茂茶草荒荷荘茎菊菌菓菜華万落葉著葬蒸蓄薄薦薪薫蔵芸薬藩虐処虚虜虞号蚊融虫蚕蛮血衆行術街衝衛衡衣表衰衷袋被裁裂裏裕補装裸製複襲西要覆見規視親覚覧観角解触言訂計討訓託記訟訪設許訴診詐詔評詞詠試詩詰話該詳誇誌認誓誕誘語誠誤説課調談請論諭諮諸諾謀謁謄謙講謝謡謹証識譜警訳議護誉読変譲谷豆豊豚象豪予貝貞負財貢貧貨販貫責貯弐貴買貸費貿賀賃賄資賊賓賜賞賠賢売賦質頼購贈賛赤赦走赴起超越趣足距跡路跳踊踏践躍身車軌軍軒軟軸較載軽輝輩輪輸轄転辛弁辞辱農込迅迎近返迫迭述迷追退送逃逆透逐途通速造連逮週進逸遂遇遊運遍過道達違逓遠遣適遭遅遵遷選遺避還辺邦邪邸郊郎郡部郭郵都郷配酒酢酬酪酵酷酸酔醜医醸釈里重野量金針鈍鈴鉛銀銃銅銑銘鋭鋼録錘錠銭錯錬鍛鎖鎮鏡鐘鉄鋳鑑鉱長門閉開閑間閣閥閲関防阻附降限陛院陣除陪陰陳陵陶陥陸陽隆隊階隔際障隣随険隠隷隻雄雅集雇雌双雑離難雨雪雲零雷電需震霜霧露霊青静非面革音韻響頂項順預頒領頭題額顔願類顧顕風飛翻食飢飲飯飼飽飾養餓余館首香馬駐騎騰騒駆験驚駅骨髄体高髪闘鬼魂魅魔魚鮮鯨鳥鳴鶏塩麗麦麺麻黄黒黙点党鼓鼻斎歯齢猿凹渦靴稼拐垣殻潟喝褐缶頑挟矯襟隅渓蛍嫌洪溝昆崎桟傘肢遮蛇酌汁塾尚宵縄壌唇甚据杉斉逝仙栓挿曹槽藻駄濯棚挑眺釣塚漬亭偵泥搭棟洞凸屯把覇漠肌鉢披扉猫頻瓶雰塀泡俸褒朴僕堀磨抹岬妄厄癒悠羅竜戻枠媛怨鬱唄淫咽茨彙椅萎畏嵐宛顎曖挨韓鎌葛骸蓋崖諧潰瓦牙苛俺臆岡旺艶稽憬詣熊窟串惧錦僅巾嗅臼畿亀伎玩挫沙痕頃駒傲乞喉梗虎股舷鍵拳桁隙呪腫嫉𠮟叱鹿餌摯恣斬拶刹柵埼塞采戚脊醒凄裾須腎芯尻拭憧蹴羞袖汰遜捉踪痩曽爽遡狙膳箋詮腺煎羨鶴爪椎捗嘲貼酎緻綻旦誰戴堆唾鍋謎梨奈那丼貪頓栃瞳藤賭妬塡填溺諦阜訃肘膝眉斑阪汎氾箸剝剥罵捻虹匂喩闇弥冶冥蜜枕昧勃頰頬貌蜂蔑璧餅蔽脇麓籠弄呂瑠瞭侶慄璃藍辣拉沃瘍妖湧柿哺楷睦釜錮賂毀勾垓𥝱穣澗]>

        }  

    token number-kanji { 
        | '一' | '二' | '三' | '四' | '五' | '六' | '七' | '八' | '九' | '十' 
        | '壱' | '弐' | '参' | '肆' | '伍' | '陸' | '漆' | '捌' | '玖' | '拾'                  
        | '弌' | '弍' | '弎'                      | '柒'       
        | '壹' | '貳' 
               | '貮' 
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

}


