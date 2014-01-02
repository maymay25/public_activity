require File.expand_path('../../config/environment', __FILE__)

# pool_data = JSON ALL_TRACKS_POOL_SERVICE.getTracks(p,limit)

# puts pool_data.class

#user_ids = RECOMMEND_SERVICE.mostFollowedUserList(nil, 1, 1000)

# log_path = File.join(CORE_ROOT, "log/jeffrey2013-08-19.log")
# logger ||= Logger.new(log_path)
# logger.info "#{user_ids.join(",")}"

uids = [1012757,1017777,1000303,1000289,1734527,1000596,1412963,1412961,1000694,1000202,1000271,1070679,1012676,1000179,1000120,1000256,1000584,1000072,1000140,1203478,1219199,1000062,2073432,1013381,1000241,1000106,1000155,1412929,1000710,1000678,1000108,1048006,1012392,1000099,1000322,1000527,1000059,1000105,1000055,1000302,1161987,1000116,1000211,1000663,1000634,1012382,1347982,1000168,1288558,1681999,1000499,1662220,1002118,1869580,1000113,1235877,1013246,1000604,1287790,1259781,1000057,1014267,1000156,1012414,1412956,1333953,1000722,1021519,1412950,1000359,1000112,1000324,1000700,1587644,1288290,1000723,1000178,1199493,1000257,1000081,1000122,1014034,1021005,1102179,1000338,1013761,1162654,1000334,1450037,1000242,1000157,1000692,1000574,1000119,1013466,1000259,1000294,1017918,1000482,1210148,1412883,1000060,1000481,1012242,1520397,1000585,1000627,1013698,1850639,1031432,1000621,1000265,1537778,1000673,1372242,1012412,1000746,1000293,1000056,1118373,1316489,1018912,1585275,1110483,1029531,1361158,1354006,1000123,1000345,2132667,1000159,1000115,1016033,2140239,1047487,1266964,1000258,1000114,1018694,1000341,1000480,1007098,1000301,1000691,1563583,1032042,1545344,1372468,1325513,1000209,1131179,1000483,1347956,1000573,1002084,1013796,1000697,1012680,1000274,1000599,1000079,1392387,1800244,1209134,1000295,1170335,1030320,1604661,1016390,1000730,1786633,1032618,1320293,1274082,1318776,1412955,1288480,1686754,1000134,1368223,1051203,1870223,1000505,1298202,1039828,1521708,1340942,1000297,1259545,1051741,1014895,1000484,1217385,1000631,1029792,1374220,1412935,1013334,1000661,1000625,1000118,1342948,1000479,1000566,1000085,1459564,1000084,1217043,1000583,1000076,1112334,1000160,1000339,1246523,1015630,1357030,1048414,1566620,1000565,1804585,1344248,1000053,1029888,1172121,1363527,1309661,1000647,1000104,1214928,1030055,1000645,1071515,1293616,1012258,1000619,1929366,1608009,1315441,1013511,1017332,1000636,1017142,1372452,1000714,1041555,1283110,1592627,1016746,1012403,1038013,1190983,1650934,1344031,1794727,1000315,1012565,1000515,1639791,1355842,1613466,1383126,1020975,1473008,1218273,1087271,1606964,1000608,1538465,1000316,1615824,1046409,1591179,1201528,1000320,1625559,1000167,1443839,1034712,1000598,1000262,1480138,1412958,1608162,1271865,1000411,1014842,1039285,1000235,1512962,1000286,1014610,1012587,1289524,1752817,1000658,1084167,1000097,1033939,1453790,1288349,1000275,1014612,1000632,1870616,1000125,1000121,1000109,1438962,1000054,1361723,1267160,1273679,1000417,1012705,1000073,2071282,1057231,1438008,1000868,1000071,1017433,1441910,1412923,2228619,1000329,1625464,1000310,1000740,1308559,1000666,1281522,1000623,1000620,1012238,1072622,1023979,1107762,1070032,1240550,1000170,1000238,1079959,1673389,1204092,1000477,1000342,2104878,1029515,1000670,1048295,1719916,1014553,1000330,1075353,1191711,1016989,1000255,1000579,1473420,1247689,1454701,1303511,1675887,1013709,1000077,1022236,1013579,1000223,1000376,1860534,1000064,1637537,1838494,1013372,1000268,1000175,1730416,1012675,1000485,2216038,1908529,1000052,1000362,1376249,1571222,1000304,1000606,1000656,1240034,1412970,1000205,1014546,1412962,1557355,1000107,1346706,1129533,2396664,1480000,1596968,1527099,1084670,1714122,1389489,1000319,1029868,1000466,1036626,2127929,1118899,1000176,1052009,1192731,1014136,1144695,1000135,1000355,1457581,1000221,1000352,1000686,1363000,1277418,1000291,1029766,1740592,1344734,1156634,1000061,1657083,1029811,1000353,1609418,1032562,1357020,1049458,1013524,1000058,1000643,1622612,1035021,1000164,1047604,1512913,1219164,1740154,1000305,1000687,1412968,2031233,1013342,1000063,1000641,1000100,1000332,1477391,1000502,1000337,1000393,1163447,1713929,1206061,1699513,2281271,1369033,1054354,1333281,1228706,1000564,1000089,1000078,1013782,1000683,1733231,1000169,1602873,1000313,1000379,1000580,1282659,1000655,1659591,1014870,1014064,1000648,1000347,1000065,1000668,1000639,1080949,1551902,1000103,2269471,1350925,1726912,1466359,1054746,1000586,1012423,1412926,1442243,1000096,1128494,1149589,1553979,1373221,1021178,2343986,1000231,1000389,1412885,1000526,1000264,1123767,1012727,1745777,1017334,1000340,1000102,1046753,1015963,1863428,2212210,1232723,1039842,1747971,1000742,1014461,1000066,1007106,1000644,1000535,1000528,1014474,1000523,1000486,1310291,1650825,1000454,1260108,1020431,1000321,1723144,1013415,2167661,1000708,1553522,1156345,1726102,1012272,1468613,1127818,1000272,1185269,1150533,1614460,1013919,2168146,1000204,1305196,1000681,1574730,1000098,1604009,1000753,1000541,1000080,1000296,1582310,1737663,1467904,1657320,1023016,1694918,2133077,1060273,1644520,2092481,1974748,1390643,1012297,1411042,1277246,1000429,1017654,1689386,1012282,1670644,1012566,1017858,1681933,1123815,1000397,1000725,1000877,1290605,1727512,1000695,1558735,1000182,1000273,1000314,1000240,1012480,1000657,2035320,1014052,1325706,1810465,1000626,1683929,1394386,1012489,1747024,1752034,1000126,1055666,1000665,2012232,1000671,1000545,1657214,1264211,1324682,1686914,1000664,1000181,1367386,1246752,1039744,1000074,1728708,1677108,1315709,1000300,1597753,1333282,1041199,1813598,1055067,1000611,1443549,1564400,1423510,1030794,1018631,1623680,1038799,1293840,1000597,1152567,1153580,1000724,1013371,1226811,1630408,2203553,1070041,2055118,1000685,1000737,1000075,1000630,1012502,1716986,1000689,1012315,1511013,1207551,1000228,1028043,1558809,1049991,1000124,1000603,1289144,1000290,1000456,1000344,1225214,1000325,1037024,1071054,1050152,1104697,1000361,1000270,1639862,1770002,1040283,1000690,1000203,1651481,1588554,1000652,1000675,1320167,1000248,1743986,1345194,1783747,1000070,1084234,1343276,1571865,1351569,1000501,1638915,1649516,1293516,1090835,1000373,1000651,1720084,1000633,1209449,1000022,1390641,1652339,1052356,1480007,1460014,1000709,1156413,1056283,1000509,1616276,1343095,1021446,1267013,1022642,1014736,1343540,1070486,1000277,1761436,2249373,1000222,1795994,1646086,1000394,1000617,1013463,1014119,1000068,1412851,1000350,1000377,1112178,1000261,1012431,1629887,1130470,1571127,1000653,1460721,1697512,1000298,1712311,1000672,1456833,2267269,1429081,1000422,1012324,2125903,1704996,1000183,1158508,1021555,1000185,2342717,1030852,1016736,1016205,1775939,1000518,1037849,1000129,1319275,1739865,1094540,1049050,1000069,1000253,1036730,1688264,1841872,1013185,1882350,1044868,1713435,1000570,1012507,1339932,1000659,2612450,1483545,1000600,1149757,1000435,1769773,1219336,1014618,1000177,1368193,1012253,1012330,1017298,1021375,1000732,1396580,1699697,1000602,1395993,1021857,1652411,1716728,1000354,1013609,1013737,1035750,1000128,1289074,1713175,1000640,1218915,1016126,1613066,1000087,1000082,1511875,1541619,1029104,1564074,1000132,1664037,1000420,1000095,2347739,1052538,1255908,1000091,1104960,1000280,1000292,1071470,1000662,1012818,1000595,1000356,1312016,1000218,1471850,1000506,1485204,1012606,1012657,1000738,1552610,1000086,1156896,1316068,1337276,1340888,1657690,1012285,1412101,1199044,1739195,1047629,1012329,1675890,1000288,1451135,1000642,1597538,1002146,1312539,1012827,2557191,1015463,1045088,1683775,1000696,2127907,1613376,1279941,1000299,1015169,1000410,1012475,1521484,1198825,1000229,1000326,1000382,1849397,1717019,1000101,1056751,1391935,1000232,1541080,1645217,1000067,1070868,1000563,1034418,1000669,1696866,1945296,1000230,1037188,1142830,1166987,1000323,1000682,1000618,1459215,1944027,2463940,1176503,1000667,1045955,1014554,1679172,1000279,1822019,1000004,1000684,1016442,1631621,1149535,1028110,1000735,1036250,2294315,1000381,1273038,1000459,1012628,1012483,1012286,1041604,2376439,1599032,1000693,1000605,1000184,1057177,1012767,1017713,1192420,1000251,1000717,1938953,1000051,1585199,1367415,2113514,2341642,1018026,1013241,1344058,1012371,1429302,1961047,1012310,1658023,1013962,1597111,1000092,1000622,1037571,1000475,1241165,1605332,1000400,1000335,1000312,1099639,1149843,1000610,1598500,1000233,1018954,2265650,1043909,1000243,1028096,1000083,1000507,1000189,1368123,1765103,2166039,1500048,1713004,1056923]


users = PROFILE_SERVICE.getMultiUserBasicInfos(uids.collect{|uid| Hessian2::TypeWrapper.new('Long', uid)})

user_followers_counts = CCOUNTER.with do |c|
  c.getByIds(Settings.counter.user.followers, uids)
end

category_map = {}
HumanCategory.all.each do |c|
  category_map[c.id] = c.title
end

File.open("most_follower_users.txt", 'wb') do |f|
  f.puts "uid\tnickname\tfollowers_count\tisRobot\tcategory"
  uids.each_with_index do |uid,i|
    user = users[uid]
    if user
      followers_count = user_followers_counts[i]
      f.puts "#{uid}\t#{user['nickname']}\t#{followers_count}\t#{user['isRobot']}\t#{category_map[user['vCategoryId']]}"
    end
  end

end

begin
  track_ids = RECOMMEND_SERVICE.recentVTrackList(nil, nil, 1, 4)
rescue RuntimeError => e
  track_ids = nil
  logger.fatal(e.backtrace.first)
end