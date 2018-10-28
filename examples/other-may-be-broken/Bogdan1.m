/***
 *  Example file
 *
 *  Written by Jeroen Sijsling (jeroen.sijsling@uni-ulm.de)
 *
 *  See LICENSE.txt for license details.
 */

SetVerbose("EndoFind", 3);
SetVerbose("CurveRec", 1);

prec := 1500;
SetDefaultRealFieldPrecision(prec + 100);
F := RationalsExtra(prec);
CC<I> := F`CC;

tauseq := [0.0028709634819086203381740654040572076341533512505652647466684988160913632077697603186534711508644126340178600863593959289698795493180966776032677521656537167134140709812398143180791664746457172214927983316350022392277395545136811283694441757479417591281704149860814908915094496459407937489778525790262660302414494401718368480428193543830059273730475883898799947196074515868072044492643596336200792113916800311545538052892875822690692913999258089412922898480862442209137878829599872249220008965066506054174797109914632701693271640317531425003609757616904850253464768328270653401932980089170657305750017561367060847035334758958768328295945447894406000712230669755628859743047330719132325420100891519193879261436942604780269656874779912144610840516880807132517940106035131103030378570347939362307423577233208156305102221045607917703677280700870691802586693987841011299225743974458296657467978648527456385204234355897487912498859192403179143297301236317235147493617399423974724274328529084527861013958457830122410946614577581180724033307329871664220438521573344188200287487068651591694872079612627539532311695719488317354342703328865698650581178544235412764411999030694861515779697640114381253125536112662551751720010056524552943466814721519279586283759879728522856490567158890659884325754569719595432584248068175969354454562638661584915783985171431706601812506194021617955958229357258765242945804092069182199456257046281622248146149688979012285247263280374308878489737733301294485344384395172048152638242771101541123570270801845217540880123615822825735437743542774347946425663628818011418976912895321817591401689588585697826118439927111844213457607421483668843923279525000508682052081593691112375599900709620967483750385981243424549888724712448467459986476138104863406315403733533562414173634027883091398653895 - 0.18073099326837347577357796526871136965860564103386702359857731543214066317116926009836964765862751560236010919021264740857352224498342303766708700136185100653178961209958591524472707223100386812068607908517476377637474430816709400494674136577172381815478074330437712224611425090821897772157747417636037165241540533155470741042782432900165721513747790913867452765361656084732445524038393225536136980949982159282020636357596941150738190408699910381625428567758125802910626594401275069739849332585127716182313833358709129315951290884112416037019484645757762440642657339699478621919422347348603850438344925942469407668025511198369644415096940147107280258555519024277172064018004743730951173277204414716835465521793304088938390137127343393535574261335522858064567015053538322562722734268883000042956064341563310464440255082722736834423142730368445131924292845796935120889327844221262393200304243715535368980862180811085885645170303186269520748177091018376242049904793680185580039046386858540821063440518841081037710781356697591207507315678555064262451961512491022938964322993363711713394435442964666906267537746525364955394507008155397592754038334758682727580126452454553549769182635742346327350380767205546213388601294275835513705001666397685556425942733259337283903548210184231305544013863194828975764081027522344532465087638368135110417400303931590620604301727009924236389908589928522730433206472087388096574501771581828111256598948931112088833585432310839611806267576503833701632851968034854910416190167356430529539199620657494771901641739704623377399560244472855147452064016865197115476086657707460752058836740750522471309753765149351181675642884667958680261062443859406145246187326456397925419187884274838046506960112936734749122722993126647385858429032703879749315955888922071306998546037361901450493405*I, -0.29613402228413983876892831594057431859214859570971642075200079891672783625272377193611356343270338151162615534574747921871212784017707077720765144854161447311969718403521335529981056113297842728358472342265976635254076856660415438850346638094287304610988962585510431761996308767223234918705572456487394651414763849760873916912219921878833529930635000198472583288039420788374175769221477037205612070427888733434987476062065027249640012986489756596404972618172815004814617265229447966106088159930731656190997494779410781639405845277070429496440507970703670016198573885541588330500201734926072601750453604927345257150490611886068251097197852188162544036462961489007126861005286611347687729810696376987111880559950675393618965552436190078349892371065569745730758168258289099841807770109442827204083708091009096124404277613673420292743145522543422549668421549078506735940488839517470000529445746395570088944178393194392379815281374863370914957707534688782952446785022513465941347350203025668205926800445297438757505725480116843605313368243724133489059938511432745285309317224330374626555589120924616426086592114415893357061566722804663505323050514096264954405756713417148624506501333347347625528374404362037361273078312169406232499090501089488610730000705965922434500352499605155574049588726641154877888965229066121993277040900300056561703077192614500386131852068800522108830937880278644634878399785236968726158716687158543297393857203584804042954452432268822513980738908729542106545572433597814004627692650129878149002690009474804085074197865564611029879520187121818904598576970844882657317827313758215029719110456190188764858388549170100517670095551732548008752887599577794314228437553645417131499306304515988593456589905689322403643068040486738280549407037024270331801534804391178888911821268456130147694996 - 0.14336847087874021027630447069445138189933451950279607279274301336353766770572590984753181648060769308097909638837381733311108857223364963238763693168642446210800522246791578304696312008390035344709333284317920171045167484254305144003286928415430522569123896770111848575637548675872861959551074426233105831444463698683593797867646571034804589758633733935967451644243027719758992208106802605335187942040071858427701390679483318123590462018398577924158961302805451365009386130272963838287813038355609496107846322250776939910110485012734725520942762217223028572442682072539773511808140125197975050778011105295118391880850379668225786791324155493316785988281891234835381569475922040168986713027721369173172853045449719595905638380113002316208319727623881383320157934339481549143674642701304380297376807010647842671871429956668998185234105717597005907671770877390285562025621891692690101932922655746209937047878483537372375320997228729650410432950145676341710034118035572120322608507745423600361314245597315763171653486910743527771956602078678213235609286301520743425854181441857286348371302650898602467498335566223158577715114263349504949450618232932196436736982410702226259032733932496331175701746000215247955037531284613515229930571757127263609291757674220986131203177903938465866649665099147923827752202099195776064781223872012182230041052079999364095491469454557231302040179502462732754569550044887039482502317925361158259270165365453590832018535278059482959165776493308163530732949169906366504544250816667148019965562884017802136242807651498224692796717421142993372628048264850025137259567696841483831974772643865184216608618184065332770863927121782649130130686813174095906843973634363898545996560552457255487166516821890512419251489009575925337034153781983881869104478853681739185880879086635852606833567*I, -0.034152685632811177914579766312745099966123649674462296725980155505146129075035802314798507394655767872358569596980294302209288460171926337701604135468038017545302772629307932417398191798811205417361195889942678852299784762691569830848575243929067307192415144885029901077083477038860401022560684360841686336621625931055751537767622791245866101244768120340321971210964868480715013398554503765099896523655687419316700099952064792781066736029533618641661817263427514936310835319445400004509164960581182347557975127066375055826102122681065988943639326913622875734672361337947946374909163367746658315268492606267105823836088717470753535842488197436765128116461576225033868934419544595639916806062456495359264718052747450748027641246227589020306715131553819285869678615105422338301382690166032649694727480493439767030252574951983669355108289144661034380043911990291434803356226082329133980024988731039976627969266240643752917917105790498162159104753948904119445779073228339970636033330817601204282695288651332672726663724553264763402827879535149875797231360619946350638954205592099104307417820232546287989998857929439393049322607194039091431781699466353648636674857828017708862972207026585940380867526095743414203570641946911038844528059127338871715065615695811456787953949117394910804810622416257494880888006740393637209480128351194592614993993213210691578696336867327343585706115645881672832239214757513728885453552053475848122059843588926432988149940674494532258518528688799477124394518654664507667301559392825404015141704679245003949166768342310396251415091541238750338225236950325709022586854680953331609541899098626431984623490548450028410714338914076780580090193110785622474233068328955805362665422697738381416709674893457241238670910372390808717838425860702594061577852263516553851502211545463542767348726 + 0.016403530260912835620452996531221067869753618121552437542395653906391174729827332389043971516856446906078394519211071622184191322588750424934578227956443670476848084519822835252237753965061865803755055235230918990347461383161597836824732350072119144120724146769048149517164021694350604295016226577769968558550516718903787907427084247865742085646067843621686922816505384190286195049601305846316841833953388921630049956775922105963029848313118549649463286938645071821564871713074441016164634794360624377797875748094550613457649772107609294682270931775885795158636091095425122144199782587842698655686562098756211703049518892685707336818789629642459107429536229634746213854145288382113719613190537005706632688091156680619623204283737603459060344379362964898382667184182277312691118569771826264047371572909571841154733800873300318455633849060236865263066839120358049331495536865212239456481419604855593420631157224644170005970147061338190475395322391540535541271028620206946960582717137181526011971943433508002655312655892326539498037280260722359638360345438085034517698541644060346687635201316631569478396461957930875285731725423720809287774354038047151672469133045460597176962718951850913892171707064647128881953407377494674943607615597646799880091830210839867254771283594014126719712128942809033596514708522349046201775476867127232723811955334902145620536501060249416315241234316753809806109061291451785181828068247689604139451310549497607514648683787139759355750493155093483676247475124333831654878616333550852106150008141507197092799838116459344908986805204204959929329617922060533561539036970431619385907421874555658068785767777101678547706577452699814887377427855908224078485031847248597383354993110876966027997330265800689057690716222514247379002768232915529145007872999554910345998480375431685739560253*I, -1.0747941575036714250850810181203673859266683030484954716463543839328628775745399033110285285321988840044402069619430232420549249494380510279561208012640124679446802958660012111576884903888904429010789214588649933353230214663368372615305816910264627463039260767092789008311741248021040767516200569840357002247423196949059169069743955458186433355463518376720402056845712511812317009773047263804943731287172681631331749794411751423769048711116775359876353765006305931448355962058049021397821350667597033733277636671924083303350192003459241072600141802709932434516059066625992487270124311143448548508584435746965510081916398042156341228856233136087254440787521232570950110777891309741952682889075188271269297686961233764896419071793210228067168271407437094088986027660802556086612521282587158474444072048495691882286207228482012884234690868249586135454314564188353707362053421212838324854574931928229582615059286562683711256553884620275778401494590328950257699288499470776750830367632137282082074752535578682378302441492959179528148089582029133094760743761698132640760171402315983148886189240968771282792204575160127674386270386308498823223404109975223403183414757102955324263102196836863152297055452911904833858446202690685160676577402301247009585909484401597168837028451342278866460136922095428063742821330076844649969558516751151169575226552462672916022699499339199915495005564608246675779996018241215838368479956258789655655086877465628604111860374703860348014367514029270199153255740395513440332362860728087578723779023646140688021161666148277299472104225161758257804659153799073852521880546547594221952871459102515007255924024243277678217939553345470941862140261601859603675183556103212097256722798387627943502918518118796872171535036203414647589567101575652389605894271540898011431191810885178668019423 - 0.16771475189043129282158358678065456867391723713110066921267522642275696690273647960138347266411312261874873626144842107495538443709711124227357923016371356524406224078395187139052061163358654405744144195902845884502565303347051796221263927648627793691048345819377813126845288751788981562665480392821809315751362400281841773744682157133057581021407185905764963096212388645717572031703903860849357933647180451183848596625158616949579643963794500089000331485957797301743938403860144080254886960500421172238576439601017020202873727371974056150459603417496577423788857928857109374578104592564606756231907784378062133651758208748257044510698814434412194142820876655336084375006931066820810531365822401364716445781660568209893914905919731210259199928687304398289496667181469170464474779785704694714086014189659562008656751903999282464645639474620804940874706631741323931473668958908131731206692309724085353149773947391531585048551691389721688397795801472926386647939831498073260290153208498221620829404451867125293504258188773935865642701838929406487423444204648332166521961840673756161781970849097380443574600028475160985939668057670460754334886384061406312633601729045906796147097075146976381892283561174935920396532354527590593485769146909753147794365141190067511042524017950437909960952662987835786561617076817742954445469579685028600130618985628904044480519204747613772110533974000172846237675705093720429047828732226960296314172954019946873213359949807785769906136263882451268285038013092290027478899786895928481856522420991774120068434715307815642258174138965291385545254544979417064470768103501041390838419883801340745054408734546772949455592977495186987505347677599085114769535051478575252878332599618081998169587994578456047258332285665070939604330079218097149886076355985189099085941579032514733853112*I, 0.15401072760930785433875091378727917583063714138164689215834950826310833119892989734867470504920686618791019316398612779482891931076455747729146624236146481978249336382995548026632664291754762435883456556228486890829865177574637590319416861593936307581170523338052107646111538663149741768573711848068805080623820375993984675042310730025000020587335040778466998733802453520494345971758266964832765315438879353484685710270075556830435982870093996031424807091671936796244626787889895907965735609057813522969755523070722654570164356863877494138325353428417733209077677494665984899748638018742848312555666828821125472660572831755340379883704863345764361456317120810181399452465018812531476350726692990591010539921032043573488277073270129288213903225285348060105015779170201322066155748502772448563878863447879947452698956100635716969546821049594220210940295572653666771643303312142559144632525541084512765991862763472866090091463061954129991631300306793087708774583550673575332658334104848369211465998146487649064096462907015431589158263656699734937977765322869041880224596438331312199867086883404265378828906651542982575895621701279356058769137193798974866555881109453388507321807433981960033587705610579466310758010986808924778751400710386293335382742392146756290359891361529709159736165890190299438672958879971515714592349434987020510300732729859847717264944170464789583331806515780402625971042432154617086411703837325431208746407162016345886648584531405236688117718290891369460482737718375522737382357954572321234293953126512774468720277741937110825660959694877351227539918644529829962642247365739718220303317428493137117053287433706579414081714386387168596297066130264668445853756605137699378181156988549226949751985450294279226991946376744244437780884136788533957068477767240716411720619733198231296381148 + 0.022088641269643739557218205611838592962234044784796443064851213170063949465169752099011720908532287966626516820864849124754519857987472560259227981741732589200668868332641734626237559580599110074045082923755641034930873827024336701157782929016594893073717929825328797700713219598264338231145956949629303661456536265491450699192210495685780959590038637378998067139159712604732825401774455822847355123760138705145222004667237093361126200585889010354125654786506456440460422554516348135757837224966335555076272332879678169381160812174531018271438218312213017000540710831428016274134911496801784479051760957491563194127086511093200718721994760262034708149530980693109994583793987937171539417119032145088225609566101135768504651824517331489418071673800197404110501234854741527518768723208478410666771386163538732669743793391812237818114790239440278542048998891955616613366330731681249636218367394086316532367123899262665111218169039473454295563924408355552959516237007901918444839129848777877015263746473970022970094363711001612821260696948023086421958207098967764598969933015340218809199847816019759959975173241739446741963673578923313537309647072604554101598583522540788733755110747719963600947459506261847397614135355972009312068222017249119764441812435315894499077834413225944297080684656739524258642441896240841527605251999203989262704925256382355174325861050045122391714120294631703632980502528997123837953448840392172573757942444773511057724192198344787835261906683735417838203673849429298482842215684264354867875782547619361267292412442300025309618327150357017293706318833102104325708642615108743128811685764839400939498781136338001367029277806948964509524263800310576195382953508280853701055232947863390304128564670112022920419616890429201804479130504460738134065602347619682714224598140506316929016300*I, -0.59372317227866694015787027305528033879788510684067453019734239187840370727575832076414536141357964647536177365933998384755212591852619247716106260109654978596171376328082082701709557725078000424311584835187107257569184084086039716479608688616490581364970383137587804133268258955593993674495202651237983735336319219898483459022581880917896016481915229078651931462432067661275008500650503231580873629356892543709407121940832135324662225193935285246833423224078858169950881183464987776399392926605054818497583486634911373011808073598442723585877544126555635272905168128671014230862662302557751440785814981673126975707093159830953590894261663085271168168643227388208630955798661028402985332686014036562651658605784864927444491229737717502027116380802464811163606756426280594664203194688905368410172386835499045499380381528153134537490255072601552336356460403924939305337179165252545495156758302335158960103249072166289132461088993610385392416343778317283334506935846835430956566179325033377715259648451840318947173193586949972204422538809452427211293786736077995163646468483518349440458263031302546969380342720687199583585233397742356378110799769800593026084210822650830066530955657873050702213514773053351101147353570486410624187300075446571389681083140015002469409108147505123412496779052795646565398556854446118992450709605637396964117396295943816155785408473410780209914414860546859027287864871894088735017466974115185101516105604386544564945722154047267940034627242383809849713310035036761559395194369194761911965008703558263301604955417964774543052088541856054752679929119501706994678570467683158281801295891595497389869344274347981085511025644417669438017095343111193534739416825579784122016422040771825333306371974157079200168711352745304080917195384516436956208232137037789552900841362716779515536908 - 0.19513470505616571862976839391792914468980002670280981565552464407130054867516200707534439341482272239636403614481479762500908310498764480901586932238777462753029413115298820340472584919638903580217787830015756275740751758403750494430190476614770468466965749223046715183793634412861374967299505968497104397004925088636868820133682498858688050190542004819493957727814811407892143155504352099625113429120344524008339526373623060811999638765754598475434473794395802890723539419007775129983734289150029292647981022255238545829397809221779170765308698002467274479714224803120762457090408989276367881709340658164571462985719882838120285036986413502523847125749904061654575673046072980736903097623831349598817922512060305299019705081644510405519441274221852387474017289186603564373985821144791921052047822149588777201276903561963234870782366133208999208529346403010949861256638465262720749490717043095126567452754955554014667219443944722539175337633891446562865576776802511887434309082543747070817853972728971593365939447301541819223802998143336647302590868366111700298730892188665267910623017186107475769937221476011466453598034627300747500989550260501001018691524994954333676869551295609816455285765545803243937306600996771387275866281696036460656604013950454065216321357343164323288857816034368242588563749108711601755236615045270696566828527347416366396032112291797167651713010522079658280891939468868516020970866032382783081059544825234804643806667728843245078883049728420386277706670381913930304845194731128014385336812749967225274885977038938103963508276902258837018665588205431469779514793482702060921310813005059064958243260687783407302093651256193128743687347432346283962588095092795120822644840980149540199843794926164498479813242460298429713389642223283112278606856570176328561128169026985325785755372*I ];

tau := Matrix(CC, [ [ tauseq[1], tauseq[2], tauseq[3] ], [ tauseq[2], tauseq[4], tauseq[5] ], [ tauseq[3], tauseq[5], tauseq[6] ] ]);
tau := -tau;
assert IsSmallPeriodMatrix(tau);
tau := ReduceSmallPeriodMatrix(tau);

P := HorizontalJoin(IdentityMatrix(CC, 3), tau);
EndoRep := GeometricEndomorphismRepresentation(P, F);
Alg, Desc := EndomorphismAlgebraAndDescriptionBase(EndoRep);

rosensCC := RosenhainInvariantsBILV(tau);
RCC<xCC> := PolynomialRing(CC);
fCC := &*[ xCC - rosenCC : rosenCC in rosensCC ];
coeffsCC := Coefficients(fCC);

L, coeffs := NumberFieldExtra(coeffsCC, F);
R<x> := PolynomialRing(L);
f := x*(x - 1)*(R ! coeffs);
X := HyperellipticCurve(f);
print X;
print L;

S, W := ShiodaInvariants(X);
S0 := WPSNormalize(W, S);
K := sub< L | S0 >;
S0 := [ K ! inv : inv in S0 ];
K0, hKK0 := Polredbestabs(K);
S0 := [ hKK0(inv) : inv in S0 ];

print S0;
print K0;


