-- ##### begin force_add.lua by @ToOfan ####

local function BeyondTeam(msg)
	if not is_mod(msg) then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local username = ''
		local chsh = 'addpm'..msg.to.id
		local hsh = redis:get(chsh)
		local chkpm = redis:get(msg.from.id..'chkuserpm'..msg.to.id)
		local add_lock = redis:hget('addmeminv', msg.to.id)
		if add_lock == 'on' then
			local setadd = redis:hget('addmemset', msg.to.id) or 10
			if msg.adduser then
				-- if you want can add robots, commented or deleted this codes
				if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
					if not hsh then
						if not lang then
							tdcli.sendMessage(msg.to.id, 0, 1, '_You Added a Robot!_\n_Please Add a Human! :)_', 1, 'md')
						else
							tdcli.sendMessage(msg.to.id, 0, 1, '_شما یک ربات به گروه اضافه کردید_\n_لطفا یک کاربر عادی اضافه کنید._', 1, 'md')
						end
					end
					return
				end
				-- check here
				if msg.from.username then
					username = '@'..check_markdown(msg.from.username)
				else
					username = check_markdown(msg.from.print_name)
				end
				if #msg.content_.members_ > 0 then
					if not hsh then
						if not lang then
							tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_You added '..(#msg.content_.members_ + 1)..' users!_\n_But One user saved for you!_\n_Please add one by one user._', 1, 'md')
						else
							tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_شما تعداد '..(#msg.content_.members_ + 1)..' کاربر را اضافه کردید!_\n_اما فقط یک کاربر برای شما ذخیره شد!_\n_لطفا کاربران رو تک به تک اضافه کنید تا محدودیت برای شما برداشته شود_', 1, 'md')
						end
					end
				end
				local chash = msg.content_.members_[0].id_..'chkinvusr'..msg.from.id..'chat'..msg.to.id
				local chk = redis:get(chash)
				if not chk then
					redis:set(chash, true)
					local achash = 'addusercount'..msg.from.id
					local count = redis:hget(achash, msg.to.id) or 0
					redis:hset(achash, msg.to.id, (tonumber(count) + 1))
					local permit = redis:hget(achash, msg.to.id)
					if tonumber(permit) < tonumber(setadd) then
						local less = tonumber(setadd) - tonumber(permit)
						if not hsh then
							if not lang then
								tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_You invited_ `'..permit..'` _users in this group._\n_You must invite_ `'..less..'` _other members._', 1, 'md')
							else
								tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_شما تعداد_ `'..permit..'` _کاربر را به این گروه اضافه کردید._\n_باید_ `'..less..'` _کاربر دیگر برای رفع محدودیت چت اضافه کنید._', 1, 'md')
							end
						end
					elseif tonumber(permit) == tonumber(setadd) then
						if not hsh then
							if not lang then
								tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_You can send messages now!_', 1, 'md')
							else
								tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_شما اکنون میتوانید پیام ارسال کنید._', 1, 'md')
							end
						end
					end
				else
					if not hsh then
						if not lang then
							tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_You already added this user!_', 1, 'md')
						else
							tdcli.sendMessage(msg.to.id, 0, 1, username..'\n_شما قبلا این کاربر را به گروه اضافه کرده اید!_', 1, 'md')
						end
					end
				end
			end
			local permit = redis:hget('addusercount'..msg.from.id, msg.to.id) or 0
			if tonumber(permit) < tonumber(setadd) then
				tdcli.deleteMessages(msg.to.id, {[0] = msg.id_}, dl_cb, nil)
				if not chkpm then
					redis:set(msg.from.id..'chkuserpm'..msg.to.id, true)
					if not lang then
						tdcli.sendMessage(msg.to.id, 0, 1, (check_markdown(msg.from.username) or msg.from.print_name)..'\n_You must add_ '..setadd..' _users, so you can sending message!_', 1, 'md')
					else
						tdcli.sendMessage(msg.to.id, 0, 1, (check_markdown(msg.from.username) or msg.from.print_name)..'\n_شما باید_ '..setadd..' _کاربر دیگر رابه به گروه دعوت کنید تا بتوانید پیام ارسال کنید_', 1, 'md')
					end
				end
			end
		end
	end
end

local function ToOfan(msg, parts)
	if is_mod(msg) then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		if parts[1]:lower() == 'unlock' then
			if parts[2]:lower() == 'add' then
				local add = redis:hget('addmeminv' ,msg.to.id)
				if not add then
					redis:hset('addmeminv', msg.to.id, 'off')
				end
				if add == 'on' then 
					redis:hset('addmeminv', msg.to.id, 'off')
					if not lang then
						return '*Limit Add Member Hash Been* `Unlocked`'
					else
						return '*محدودیت اضافه کردن کاربر* `غیرفعال` *شد*'
					end
				elseif add == 'off' then
					if not lang then
						return '*Limit Add Member Is Already* `Unlocked`'
					else
						return '*محدودیت اضافه کردن کاربر از قبل* `غیرفعال` *بود*'
					end
				end
			end
		end
		if parts[1]:lower() == 'lock' then
			if parts[2]:lower() == 'add' then
				local add = redis:hget('addmeminv' ,msg.to.id)
				if not add then
					redis:hset('addmeminv', msg.to.id, 'on')
				end
				if add == 'off' then 
					redis:hset('addmeminv', msg.to.id, 'on')
					if not lang then
						return '*Limit Add Member Hash Been* `Locked`'
					else
						return '*محدودیت اضافه کردن کاربر* `فعال` *شد*'
					end
				elseif add == 'on' then
					if not lang then
						return '*Limit Add Member Is Already* `Locked`'
					else
						return '*محدودیت اضافه کردن کاربر از قبل* `فعال` *بود*'
					end
				end
			end
		end
		if parts[1]:lower() == 'setadd' and parts[2] then
			if tonumber(parts[2]) >= 1 and tonumber(parts[2]) <= 10 then
				redis:hset('addmemset', msg.to.id, parts[2])
				if not lang then
					return '*Add Member Limit Set To:* `'.. parts[2]..'`'
				else
					return '*تنظیم محدودیت اضافه کردن کاربر به:* `'.. parts[2]..'`'
				end
			else
				if not lang then
					return '_Range Number is between_ *1 - 10*'
				else
					return '_تعداد باید مابین_ `1 - 10` _باشد_'
				end
			end
		end
		if parts[1]:lower() == 'getadd' then
			local getadd = redis:hget('addmemset', msg.to.id)
			if not lang then
				return '*Add Member Limit:* `'..getadd..'`'
			else
				return '*محدودیت اضافه کردن کاربر:* `'..getadd..'`'
			end
		end
		if parts[1]:lower() == 'addpm' then
			local hsh = 'addpm'..msg.to.id
			if parts[2] == 'on' then
				redis:del(hsh)
				if not lang then
					return '*Add PM has been* `Activated`'
				else
					return '*ارسال پیام محدودیت کاربر* `فعال` *شد*'
				end
			elseif parts[2] == 'off' then
				redis:set(hsh, true)
				if not lang then
					return '*Add PM has been* `Deactivated`'
				else
					return '*ارسال پیام محدودیت کاربر* `غیرفعال` *شد*'
				end
			end
		end
	end
end
 
return {
  patterns = {
	'^[!/#]([Ll]ock) (.*)$',
	'^[!/#]([Uu]nlock) (.*)$',
	'^[!/#]([Aa]ddpm) (.*)$',
	'^[!/#]([Ss]etadd) (%d+)$',
	'^[!/#]([Gg]etadd)$',
  },
  run = ToOfan,
  pre_process = BeyondTeam
}

-- End force_add.lua
-- Coded by @ToOfan
-- Channel @BeyondTeam
-- Fuck You, Ski :)