ComponentLoad = {}
math.randomseed(tostring(os.time()):reverse():sub(1, 7))  
DataBase = {}

--游戏平衡常数
Time = 0
--RateHunger = 5

--存储单位的表，key为编辑器内单位id
UnitTable = {}

--资质影响的属性值———体质：防御,体力恢复,健康恢复；爆发：攻击,命中,移速；灵敏：攻速,连击,闪避；精神：感知,抗性,理智恢复；技巧：暴击,格挡,反击；
QuaData = {
    --QuaData["Str1"] = 2;QuaData.Str1 = 2;与下面等价
    Str1 = 2;--防御,体力恢复,健康恢复
    Str2 = 0.1;
    Str3 = 0.1;
    Pow1 = 2;--攻击,命中,移速
    Pow2 = 0.01;
    Pow3 = 2;
    Dex1 = 0.01;--攻速,连击,闪避
    Dex2 = 0.01;
    Dex3 = 0.01;
    Int1 = 2;--感知,抗性,理智恢复
    Int2 = 2;
    Int3 = 0.1;
    Ski1 = 0.01;--暴击,格挡,反击
    Ski2 = 0.01;
    Ski3 = 0.01;

    --单位1级各项资质初始值指数--指数*实际资质成长=初始资质值
    QuaInit = 3
}

UnitAttribute = {"魔法上限","生命","理智","魔法","生命恢复速度","理智恢复速度","魔法恢复速度","攻击","护甲","感知","意志","攻击速度","移动速度","命中","闪避","暴击","格挡","连击","反击"}

--周期--Period[1] = "child"
Period = {"child","adult","old"}

--状态--Period[1] = "digest-forage"
State = {
    "digest-forage",--消化-觅食
    "tension-relax",--紧张-放松
    "entertain-work",--娱乐-工作
    "estrus"--发情
}

--Buff
Buff = {}











PackageToUnit = {}
PackageToUnit["1227894868"] = 3
PackageToUnit["1227894834"] = 4
PackageToUnit["1227894871"] = 5
PackageToUnit["1227894872"] = 6

FeedType = {}
FeedType["1227894870"] = "Vegan"--小麦
FeedType["1227894849"] = "Vegan"--干草

FeedingHabits = {}
FeedingHabits["Omnivore"] = {"Meat","Vegan"}
FeedingHabits["carnivore"] = {"Meat"}
























return DataBase
FunctionBase = {}

--表赋值———t赋给新表tm
function ClassTable_Transfer(t,tm)
	local c = getmetatable(t)
	for k,v in pairs(c) do--找到表内方法，全部复制够来
		if type(c[k]) == "function" then
			tm[k] = c[k]
		end
	end
	for k,v in pairs(t) do--将表t的内容赋给tm新表
		tm[k]=v 
	end
	t = {}--删除被赋值的表，节省空间
end

--范围随机———a：中心数；b：变动范围，单位1/10
function Rrandom(a,b)
	local m = math.random(10-b,10+b)
	return a*m/10
end

--资质指数———每项资质影响的三个属性的比率，最低0.5最高1.5，三项和为3--计算过程：X=1.5  Y<1；0.5<Y<3-(X+Zmin)；X=0.5  Y>1；3-(X+Zmax)<Y<1.5
function QuaRandom()
	local x,y,z
	x = math.random(5,15)
	if x >10 then
		y = math.random(5,25-x)
	else
		y = math.random(15-x,15)
	end
	z = 30 - x - y
	return x/10,y/10,z/10
end

--单位生成———单位( race, lv，坐标x，坐标y，所属player，对应物编单位)
function UnitCreate(race, lv, x, y , p, num)
	local a = race(M,lv)--声明类Race，并生成生物各项属性
	a.id = IUnitCreate(x,y,p,num)--对接游戏单位创造接口，并获取返回的单位id
	UnitTable[id] = a--编辑器内可通过id来获得库内的单位表
	IUnitDataFix(a)--为单位生成固定属性（四值上限均为100）
	InterFaceQuaF(a)--单位数据更新，与单位的类数据匹配
	return a--返回生成的类Race
end

--饱食度变化
function Change_SI(u,cause,value)
	--记录此次数值变化（原因、数值），分别存入正面记忆和负面记忆	
	if value > 0 then
		table.insert(u.Pmemory_SI, { cause, value })
	else
		table.insert(u.Nmemory_SI, { cause, value })
	end
	--判断此次消耗饱食是否会导致扣除健康值
	local H = u.SI + value
	if H >= 0 then
		u.SI = H--执行数值变化
	else
		u.SI = 0--执行数值变化
		Change_HP(u,"hunger", -0.1 * u.MaxHP)--扣除健康值执行
	end
end

--健康值变化
function Change_HP(u,cause,value)
	--记录此次数值变化（原因、数值），分别存入正面记忆和负面记忆	
	if value > 0 then
		table.insert(u.Pmemory_HP, { cause, value })
	else
		table.insert(u.Nmemory_HP, { cause, value })
	end
	--执行数值变化
	u.HP = u.HP + value
end




























return FunctionBase
--- lua_plus ---
--- skip_undefined ---
InterfaceF = {}

--#region———:Statement————————————————————
-- weee = base.get_unit_from_id(0)--从编号中获取单位
-- reeee = base.unit_get_id(e.unit)--获取单位编号
--#endregion:Statement————————————————————

--#region———:Data————————————————————
Itest1 = "$$default_units.unit.星火战士.root"
Itest = "$$world_7q4a.unit.羊.root"

--#endregion:Data————————————————————

--#region———:Function————————————————————

--创造单位
function IUnitCreate(x,y,p,num)
        base.player_create_unit_ai(base.player(p), num, base.scene_point(x, y, "default"), 0, false)
        local id = base.unit_get_id(base.get_last_created_unit())--获取最后创建单位的编号
        return id
end

--单位固定数据赋值（四值上限等）
function IUnitDataFix(a)
      	base.unit_set_ex(base.get_unit_from_id(a.id), "生命上限", a.MaxHP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "理智上限", a.MaxSP, 1)
	      base.unit_set_ex(base.get_unit_from_id(a.id), "魔法上限", a.MaxPP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "饱食上限", a.MaxSI, 1)
        
        base.unit_set_ex(base.get_unit_from_id(a.id), "饥饿速度", a.RateHunger, 1)--饥饿速率为5点/分钟
end

--单位属性对接
function InterFaceQuaF(a)
        base.unit_set_ex(base.get_unit_from_id(a.id), "生命", a.HP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "理智", a.SP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "魔法", a.PP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "饱食", a.SI, 1)

        base.unit_set_ex(base.get_unit_from_id(a.id), "体质", a.Str, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "爆发", a.Pow, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "灵敏", a.Dex, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "精神", a.Int, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "技巧", a.Ski, 1)

        base.unit_set_ex(base.get_unit_from_id(a.id), "生命恢复速度", a.RHP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "理智恢复速度", a.RSP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "魔法恢复速度", a.RPP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "饱食度消耗速度", a.RSI, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "攻击", a.Atk, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "护甲", a.Def, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "感知", a.Per, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "意志", a.Res, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "攻击速度", a.Asp, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "移动速度", a.Msp, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "命中", a.Hit, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "闪避", a.Mis, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "暴击", a.Crt, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "格挡", a.Blk, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "连击", a.Dh, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "反击", a.Ch, 1)
        
        base.unit_set_ex(base.get_unit_from_id(a.id), "暴击伤害", a.CrtP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "格挡减伤", a.BlkP, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "连击程度", a.DhD, 1)
        base.unit_set_ex(base.get_unit_from_id(a.id), "反击程度", a.ChD, 1)
end
function IF_HP(a)
        base.unit_set_ex(base.get_unit_from_id(a.id), "生命", a.HP, 1)
end
function IF_SP(a)
        base.unit_set_ex(base.get_unit_from_id(a.id), "理智", a.SP, 1)
end
function IF_PP(a)
        base.unit_set_ex(base.get_unit_from_id(a.id), "魔法", a.PP, 1)
end
function IF_SI(a)
        base.unit_set_ex(base.get_unit_from_id(a.id), "饱食", a.SI, 1)
end

--#endregion:Function————————————————————

return InterfaceF
Class = {}

--#region———:辅助块——————————————————————

--#region———:监控——————————————————————
EntityId = 1
M = {}
setmetatable(M, {
    _newindex = function(t,k,v)
end
})

function M(obj)--转换obj实例为监控函数
    local obj1 = {}
    obj1 = Monitor(self)
    ClassTable_Transfer(obj,obj1)
    return obj1
end
--endregion:监控——————————————————————

--#region———:Class实现——————————————————————

    local function __index(t, k)
        local p = rawget(t, "_")[k]--先从obj表下的_表读取对应的键
        if p ~= nil then --如果有直接返回
            return p[1]  
        end
        return getmetatable(t)[k]  --没有则去元表，即c中查找
    end

    local function __newindex(t, k, v)
        local p = rawget(t, "_")[k]
        if p == nil then  --如果不是被代理则直接在实例表中修改
            rawset(t, k, v)
        else --如果是被代理的，取出对应的值修改，并触发一个预设的函数
            local old = p[1]
            p[1] = v  --修改
            p[2](t, v, old)  --这里是一个函数调用
        end
    end

    local function __dummy()
    end

--endregion:Class实现——————————————————————

--#endregion:辅助块——————————————————————

function Class(base,_ctor,props)--Class函数声明
    local c={}
    --部分1
    if not _ctor and type(base)=="function" then
        _ctor=base
        base=nil
    elseif type(base) == 'table' then
        for k,v in pairs(base) do
            c[k]=v 
        end
        c.base = base
    end
    --部分2
    if props ~= nil then --如果props表存在，即有需要代理的键，则替换元函数
        c.__index = __index
        c.__newindex = __newindex
    else
        c.__index = c
    end
    --部分3
    local mt={}
    mt.__call=function(class_tbl,Monitor,...)
        local obj={}
        if props ~= nil then --如果需要代理，则遍历，在_表中生成对应的结构
            obj._ = { _ = { nil, __dummy } } --对_做代理，禁止外部通过键访问到真正的_表，__dummy是一个空函数,不过通过rawget rawset还是能拿到
            for k, v in pairs(props) do
                obj._[k] = { nil, v }
            end
        end
        setmetatable(obj,c)

        if Monitor == M then
            if c._ctor then
                c._ctor(obj,...)
            end
            obj = M(obj)
        else
            if c._ctor then
                c._ctor(obj,Monitor,...)
            end
        end
        obj.uid = EntityId--定义实例的uid
        EntityId = EntityId + 1
        return obj
    end

    c._ctor=_ctor 
    --[[
    c.is_a = function(self,klass)
        local m = getmetatable(self)
        while m do
            if m == klass then return true end
            m = m._base 
        end
        return false
    end
    ]]--
    setmetatable(c,mt)
    return c
end

return Class
ClassMonitor = {}
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--region———:Monitor函数声明——————————————————————

--健康值相关
function M_HP(self, HP, old_HP)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_HP) == "table" or self.id == nil then
		return
	end
	--四维数值为负数时的判定，直接变为0
	if HP < 0 then 
		self.HP = 0
	end
	if HP < 10 then
		print("!!!")
	end
	--异常抛出
	pcall(function()
		IF_HP(self)
	end)
end

--理智值相关
function M_SP(self, SP, old_SP)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_SP) == "table" or self.id == nil then
		return
	end
	--四维数值为负数时的判定，直接变为0
	if SP < 0 then 
		self.SP = 0
	end
	--异常抛出
	pcall(function()
		IF_SP(self)
	end)
end

--体力值相关
function M_PP(self, PP, old_PP)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_PP) == "table" or self.id == nil then
		return
	end
	--四维数值为负数时的判定，直接变为0
	if PP < 0 then 
		self.PP = 0
	end
	--异常抛出
	pcall(function()
		IF_PP(self)
	end)
end

--饱食度相关：消化系统
function M_SI(self, SI, old_SI)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_SI) == "table" or self.id == nil then
		return
	end
	local d = SI - old_SI--变化值
	--四维数值为负数时的判定，直接变为0，然后赋值饱食度
	if SI < 0 then 
		self.SI = 0
	end
	--异常抛出
	pcall(function()
		IF_SI(self)
	end)
	

	if d<0 then--此次变化值为负&正
		--判断此次（即记录中最后一次添加的饱食度变化记录中）饱食度变化原因是否为“消化”，是则增加对应营养值
		if self.Nmemory_SI[#self.Nmemory_SI][1] == "digestion" then
			self.Nutrient = self.Nutrient + (-1)*d*self.Nutrient_conver[self.Period]
			print("消耗饱食度:"..(-1)*d.."，增加营养值："..(-1)*d*self.Nutrient_conver[self.Period])
		end
	else

	end
end

--升级相关
function M_Lv(self, Lv, old_Lv)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_Lv) == "table" or self.id == nil then
		return
	end
	--触发升级时，对应属性变化
	local l = Lv - old_Lv
	if l > 0 then
		--log.info("id为："..self.id.."的单位触发升级".."，从"..old_Lv.."升到"..Lv.."，当前等级为："..self.lv)
		self:AttribF()--资质&属性更新
		InterFaceQuaF(self)--接口属性对接
	end
end

--生命活动相关
function M_VitalActivity(self,Nutrient,old_Nutrient)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_Nutrient) == "table" or self.id == nil then
		return
	end
end

--成长相关
function M_Growth(self,Growth,old_Growth)
	--老数值为表（第一次创建该值）或单位id为空时，直接结束整个函数	
	if type(old_Growth) == "table" or self.id == nil then
		return
	end
	if self.Growth >= 100 then
		self.Period = self.Period + 1
		self.Growth = 0
		print("单位"..self.id.."触发周期迭代，目前周期为："..Period[self.Period]..self.Period)
	end
end

function M_Period(self,Period,old_Period)
	if type(old_Period) == "table" or self.id == nil then
		return
	end
	if self.Period > 3 then--营养值满了，触发周期迭代
		print("id为"..self.id.."的单位老死了，目前周期为："..self.Period)
	end
end

function M_Digest_Forage(self,n,old_n)
	if type(old_n) == "table" or self.id == nil then
		return
	end
	
end


--endregion:Monitor函数声明——————————————————————
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————



--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--region———:Monitor类声明——————————————————————
Monitor = Class(function(self)--Health类声明--
	self.HP = {}
	self.SP = {}
	self.PP = {}
	self.SI = {}
	self.Lv = {}
	self.Nutrient = {}
	self.Growth = {}
	self.Period = {}
	for i = 1,#State,1 do
		self["StateN"..tostring(i)] = {}
	end
	
end,
nil,
{
	HP =  M_HP, --健康值相关
	SP =  M_SP, --健康值相关
	PP =  M_PP, --健康值相关
	SI =  M_SI, --健康值相关
	Lv =  M_Lv, --升级相关
	Nutrient = M_VitalActivity,--生命相关，包括生长等等
	Growth = M_Growth,--记录百分比年纪
	Period = M_Period,--记录周期
	StateN1 = M_Digest_Forage--记录进食度

})
--endregion:Monitor类声明——————————————————————
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————



return ClassMonitor
ClassDeclaration = {}

--#region———:机制————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

	--[[资质分别影响一个隐藏属性
		体质：
		爆发
		灵敏：影响生物属性中的反应react
		精神：
		技巧：影响体力的百分比降低
	]]--

--#endregion:机制————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————




--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--#region———:Unit类声明————————————————————

Unit = Class(function(self)
--#region———:数值相关————————————————————
	--最大四维值和当前四维值默认为100
	self.MaxHP = 100
	self.MaxSP = 100
	self.MaxPP = 100
	self.HP = 100
	self.SP = 100
	self.PP = 100
	--暴击格挡连击反击机制属性暴击伤害，格挡减伤，连击程度，反击程度
	self.CrtP = 1.5
	self.BlkP = 0.67
	self.DhD = 30
	self.ChD = 30
	--默认资质相关
	self.IGStr = 1--资质成长.种族指数——1周围波动
	self.IGPow = 1
	self.IGDex = 1
	self.IGInt = 1
	self.IGSki = 1
	self.GR = 0--资质波动指数——代表x成上下波动，4代表60%~140%
	self.Lv = 1
	self.id = 0
	--默认原始属性（若有属性上的增减，即为对原始属性的增减）
	self.IRHP = 0
	self.IRSP = 0
	self.IRPP = 0
	self.IAtk = 0
	self.IDef = 0
	self.IPer = 0
	self.IRes = 0
	self.IAsp = 0
	self.IMsp = 0
	self.IHit = 0
	self.IMis = 0
	self.ICrt = 0
	self.IBlk = 0
	self.IDh = 0
	self.ICh = 0
--#endregion:数值相关————————————————————
	
--#region———:生物相关————————————————————带	tab缩进的表示非默认下可变动（其他种族）
	--*饱食相关
	self.MaxSI = 100
	self.SI = 100
	self.Nutrient = 0--营养值
		self.RSI = -5
		self.Nutrient_conver = {0.1,0.1,0.1}--三个阶段饱食度转化营养值比率，正常为10:1

	--*成长相关
	self.Period = 1--生长周期：Child、Adult、Old....
	self.Growth = 0--成长值
	self.Growth_conver = {}
		self.Growth_conver[1] = {1,2}--三种周期下，每60s会消耗Growth_conver[1]点营养值，增加Growth_conver[2]点成长值
		self.Growth_conver[2] = {1,2}
		self.Growth_conver[3] = {1,2}

	--*生物状态：状态值*状态权重 +-（正向P为+，负向N为-） 记忆参数*记忆中该状态的次数*单位反应值 
		self.react = 1--单位反应力默认为1
	for i=1,#State do--遍历全局变量 状态表的数量，表示为字符串连接的12345...
		self["StateN" .. i] = 0--每个对应的状态的初始数值为0
			self["StateW" .. i] = 1--每个对应的状态的权重  初始为1，后续根据不同种族变动
	end
	self.Pmemory_HP = {}--各项数值的正面/负面记忆库；P为正：Positive，N为负面：Negative 
	self.Pmemory_SP = {}
	self.Pmemory_PP = {}
	self.Pmemory_SI = {}
	self.Nmemory_HP = {}
	self.Nmemory_SP = {}
	self.Nmemory_PP = {}
	self.Nmemory_SI = {}
--#endregion———:生物相关————————————————————
end)

--——————————————————————————————————————————————————————————————————————————————————————————————————
--#region———:类方法————————————————————

function Unit:QuaF()--资质算法公式
	self.GStr = Rrandom(self.IGStr,self.GR)--实际资质成长——资质成长.种族指数*波动范围得到一个值
	self.GPow = Rrandom(self.IGPow,self.GR)
	self.GDex = Rrandom(self.IGDex,self.GR)
	self.GInt = Rrandom(self.IGInt,self.GR)
	self.GSki = Rrandom(self.IGSki,self.GR)
	self.QuaStr1,self.QuaStr2,self.QuaStr3 = QuaRandom()--每项资质所影响对应三个属性的百分比率，每项在16.6%~50%之间，三项和为100%
	self.QuaPow1,self.QuaPow2,self.QuaPow3 = QuaRandom()
	self.QuaDex1,self.QuaDex2,self.QuaDex3 = QuaRandom()
	self.QuaInt1,self.QuaInt2,self.QuaInt3 = QuaRandom()
	self.QuaSki1,self.QuaSki2,self.QuaSki3 = QuaRandom()
end

function Unit:AttribF()--资质&属性更新（生成&升级）
	--实际资质--初始值+Lv*成长(下面为合并同类项的简化)
	--体质、爆发、灵敏、智慧、技巧
	self.Str = self.GStr*(QuaData.QuaInit + self.Lv)
	self.Pow = self.GPow*(QuaData.QuaInit + self.Lv)
	self.Dex = self.GDex*(QuaData.QuaInit + self.Lv)
	self.Int = self.GInt*(QuaData.QuaInit + self.Lv)
	self.Ski = self.GSki*(QuaData.QuaInit + self.Lv)

	--实际属性--健康值、理智值、体力值；攻击、防御、感知、意志、攻速、移速；命中、闪避、暴击、格挡、连击、反击
	--健康值、理智值、体力值
	self.RHP = self.IRHP + QuaData.Str3 * self.QuaStr3 * self.Str
	self.RSP = 10 + self.IRSP + QuaData.Int3 * self.QuaInt3 * self.Int
	self.RPP = 15 + self.IRPP + QuaData.Str2 * self.QuaStr2 * self.Str
	--攻击、防御、感知、意志、攻速、移速
	self.Atk = self.IAtk + QuaData.Pow1 * self.QuaPow1 * self.Pow
	self.Def = self.IDef + QuaData.Str1 * self.QuaStr1 * self.Str
	self.Per = self.IPer + QuaData.Int1 * self.QuaInt1 * self.Int
	self.Res = self.IRes + QuaData.Int2 * self.QuaInt2 * self.Int
	self.Asp = 1 + self.IAsp + QuaData.Dex1 * self.QuaDex1 * self.Dex--攻速初始值为100%，可能要改
	self.Msp = 200 + self.IMsp + QuaData.Pow3 * self.QuaPow3 * self.Pow
	--命中、闪避、暴击、格挡、连击、反击
	self.Hit = 0.9 + self.IHit + QuaData.Pow2 * self.QuaPow2 * self.Pow--命中基础值为90%
	self.Mis = self.IMis + QuaData.Dex2 * self.QuaDex2 * self.Dex
	self.Crt = self.ICrt + QuaData.Ski1 * self.QuaSki1 * self.Ski
	self.Blk = self.IBlk + QuaData.Ski2 * self.QuaSki2 * self.Ski
	self.Dh = self.IDh + QuaData.Dex3 * self.QuaDex3 * self.Dex
	self.Ch = self.ICh + QuaData.Ski3 * self.QuaSki3 * self.Ski
end

function Unit:StateParameter()--资质算法公式
	for i = 1,#State,1 do
		self["StateW"..i] = self["StateW"..i] * Rrandom(1,5)
	end
end

function Unit:eat(FoodId)--Creature进食方法声明
	if FoodId == nil then
	print(self.Name.."准备进食")
	--判断物品栏内是否有可供进食的食物
	if UnitHaveFood(self ,label ) == true then
		print(self.Name.."开始进食")
		UnitEat(self ,label )--执行单位吃的动作
		print(self.Name.."结束进食")
	else
		print(self.Name.."身上无可食用食物")
	end
	else
	
	end
end

function Unit:drink()--Creature饮水方法声明
	print(self.Name.."准备饮水")
	--判断物品栏内是否有可供饮用的水
	if UnitHaveFood(self ,label ) == true then
		print(self.Name.."开始饮水")
		UnitEat(self ,label )--执行单位饮水的动作
		print(self.Name.."结束饮水")
	else
		print(self.Name.."背包里无可饮用饮水")
	end
end
--#endregion:类方法————————————————————
--——————————————————————————————————————————————————————————————————————————————————————————————————

--#endregion:Unit类声明————————————————————
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————




--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--#region———:Race类声明————————————————————

Human = Class(Unit,function(self,Lv) --继承Unit父类，id为单位id
  Unit._ctor(self) --调用父类的_ctor给obj表初始化，相当于继承了父类的元素，十分重要的一行

	self.Lv = Lv

    self.Diet = {"Meat","Vegan"}
	self.MaxAge = 100
	
	--资质相关
	self.IGStr = 1--资质成长.种族指数——1周围波动
	self.IGPow = 1
	self.IGDex = 1
	self.IGInt = 1
	self.IGSki = 1
	self.GR = 1--资质波动指数——代表x成上下波动，4代表60%~140%
	
	self:QuaF()--资质算法公式
	self:AttribF()--生成资质&属性
	self:StateParameter()--状态因子生成
end)

--#region———:类方法————————————————————



--#endregion:类方法————————————————————

--#endregion:Race类声明————————————————————
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————


return ClassDeclaration

local a = UnitCreate( Human, 1 ,300,300,1, Itest)
local au = base.get_last_created_unit()
base.player_set_hero(base.player(1), base.get_last_created_unit())--设置主控角色