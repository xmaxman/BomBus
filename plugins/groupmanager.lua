local function modadd(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
   if not lang then
        return '*You are not bot admin*'
else
     return '*شما مدیر ربات نمیباشید*'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id_)] then
if not lang then
   return '*Group is already added*'
else
return '*گروه از قبل موجود بوده است*'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.chat_id_)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      settings = {
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes'
          },
   mutes = {
                  mute_fwd = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_loc = 'no',
                  mute_doc = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.chat_id_)] = msg.chat_id_
      save_data(_config.moderation.data, data)
    if not lang then
  return '*Group has been added*'
else
  return '*آنتی اسپم ادد شد*'
end
end

local function modrem(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
     if not lang then
        return '*You are not bot admin*'
   else
        return '*شما مدیر ربات نمیباشید*'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.chat_id_
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return '*Group is not added*'
else
    return '*گروه در لیست ربات نیست*'
   end
  end

  data[tostring(msg.chat_id_)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.chat_id_)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '*Group has been removed*'
 else
  return '*گروه با موفیت از لیست گروه های مدیریتی ربات حذف شد*'
end
end
local function modlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "*Group is not added*"
 else
    return "*گروه به لیست گروه های مدیریتی ربات اضافه نشده است*"
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['mods']) == nil then --fix way
  if not lang then
    return "*No moderator in this group*"
else
   return "*در حال حاضر هیچ مدیری برای گروه انتخاب نشده است*"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
if not lang then
    return "*Group is not added*"
else
return "*گروه به لیست گروه های مدیریتی ربات اضافه نشده است*"
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['owners']) == nil then --fix way
 if not lang then
    return "*No owner in this group*"
else
    return "*در حال حاضر هیچ مالکی برای گروه انتخاب نشده است*"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "*Group is not added*", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "*گروه به لیست گروه های مدیریتی ربات اضافه نشده است*", 0, "md")
     end
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is already a group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is now the group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is already a moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل معاون بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *has been promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *معاون شد در لیست ربات*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is not a group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is no longer a group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is not a moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل معاون نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *has been demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از معاونی برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "*Group is not added*", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "*گروه به لیست گروه های مدیریتی ربات اضافه نشده است*", 0, "md")
     end
  end
if data.type_.user_.username_ and not data.type_.user_.username_:match("_") then
user_name = '@'..data.type_.user_.username_
else
user_name = data.title_
end
if not arg.username then return false end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is already a group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is now the  group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is already a moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *has been promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is not a group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is no longer a group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is not a moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *has been demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ ".. data.type_.user_.username_ .." ] :\n"
    .. "".. data.title_ .."\n"
    .. " [".. data.id_ .."]"
  else
     text = "اطلاعات برای [ ".. data.type_.user_.username_ .." ] :\n"
    .. "".. data.title_ .."\n"
    .. " [".. data.id_ .."]"
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1)
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "*Group is not added*", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "*گروه به لیست گروه های مدیریتی ربات اضافه نشده است*", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
if data.first_name_ then
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is already a group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is now the a group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is already a moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *has been promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is not a group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *is no longer a group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*User* "..user_name.." *"..data.id_.."* *has been demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر* "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
    if cmd == "whois" then
if data.username_ then
username = '@'..data.username_
else
if not lang then
username = 'not found'
 else
username = 'ندارد'
  end
end
     if not lang then
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'Info for [ '..data.id_..' ] :\nUserName : '..username..'\nName : '..data.first_name_, 1)
   else
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'اطلاعات برای [ '..data.id_..' ] :\nیوزرنیم : '..username..'\nنام : '..data.first_name_, 1)
      end
   end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User not founded*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*کاربر یافت نشد*", 0, "md")
    end
  end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "*Link Posting Is Already Locked*"
elseif lang then
 return "*ارسال لینک در گروه هم اکنون ممنوع است*"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Link Posting Has Been Locked*"
else
 return "*ارسال لینک در گروه ممنوع شد*"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "*Link Posting Is Not Locked*" 
elseif lang then
return "*ارسال لینک در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Link Posting Has Been Unlocked*" 
else
return "*ارسال لینک ازاد شد*"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "*Tag Posting Is Already Locked*"
elseif lang then
 return "*ارسال تگ در گروه هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tag Posting Has Been Locked*"
else
 return "*ارسال تگ در گروه ممنوع شد*"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "*Tag Posting Is Not Locked*" 
elseif lang then
return "*ارسال تگ در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Tag Posting Has Been Unlocked*" 
else
return "*ارسال تگ در گروه آزاد شد*"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "ش*ما مدیر گروه نمیباشید*"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "*Mention Posting Is Already Locked*"
elseif lang then
 return "*ارسال فراخوانی افراد هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mention Posting Has Been Locked*"
else 
 return "*ارسال فراخوانی افراد در گروه ممنوع شد*"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "*Mention Posting Is Not Locked*" 
elseif lang then
return "*ارسال فراخوانی افراد در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Mention Posting Has Been Unlocked*" 
else
return "*ارسال فراخوانی افراد در گروه آزاد شد*"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "*Editing Is Already Locked*"
elseif lang then
 return "*ویرایش پیام هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Editing Has Been Locked*"
else
 return "*ویرایش پیام در گروه ممنوع شد*"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "*Editing Is Not Locked*" 
elseif lang then
return "*ویرایش پیام در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Editing Has Been Unlocked*" 
else
return "*ویرایش پیام در گروه آزاد شد*"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "*Spam Is Already Locked*"
elseif lang then
 return "ارسال هرزنامه در گروه هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Spam Has Been Locked*"
else
 return "*ارسال هرزنامه در گروه ممنوع شد*"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "شما مدیر گروه نمیباشید*"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "*Spam Posting Is Not Locked*" 
elseif lang then
 return "*ارسال هرزنامه در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data)
if not lang then 
return "*Spam Posting Has Been Unlocked*" 
else
 return "*ارسال هرزنامه در گروه آزاد شد*"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
if not lang then
 return "*Flooding Is Already Locked*"
elseif lang then
 return "*ارسال پیام مکرر در گروه هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Flooding Has Been Locked*"
else
 return "*ارسال پیام مکرر در گروه ممنوع شد*"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
if not lang then
return "*Flooding Is Not Locked*" 
elseif lang then
return "*ارسال پیام مکرر در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Flooding Has Been Unlocked*" 
else
return "*ارسال پیام مکرر در گروه آزاد شد*"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "*Bots Protection Is Already Enabled*"
elseif lang then
 return "*ضدربات فعال شد*"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Bots Protection Has Been Enabled*"
else
 return "*ضدربات فعال شد*"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "*Bots Protection Is Not Enabled*" 
elseif lang then
return "*محافظت از گروه در برابر ربات ها غیر فعال است*"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Bots Protection Has Been Disabled*" 
else
return "*محافظت از گروه در برابر ربات ها غیر فعال شد*"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "*Markdown Posting Is Already Locked*"
elseif lang then
 return "*ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Markdown Posting Has Been Locked*"
else
 return "*ارسال پیام های دارای فونت در گروه ممنوع شد*"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "*Markdown Posting Is Not Locked*"
elseif lang then
return "*ارسال پیام های دارای فونت در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Markdown Posting Has Been Unlocked*"
else
return "*ارسال پیام های دارای فونت در گروه آزاد شد*"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "*Webpage Is Already Locked*"
elseif lang then
 return "*ارسال صفحات وب در گروه هم اکنون ممنوع است*"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Webpage Has Been Locked*"
else
 return "*ارسال صفحات وب در گروه ممنوع شد*"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "*Webpage Is Not Locked*" 
elseif lang then
return "*ارسال صفحات وب در گروه ممنوع نمیباشد*"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Webpage Has Been Unlocked*" 
else
return "*ارسال صفحات وب در گروه آزاد شد*"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "*You're Not Moderator*"
else
  return "*شما مدیر گروه نمیباشید*"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if not lang then
local settings = data[tostring(target)]["settings"] 
 text = "*Group Settings:*\n*Lock edit :* *"..settings.lock_edit.."*\n*Lock links :* *"..settings.lock_link.."*\n*Lock tags :* *"..settings.lock_tag.."*\n*Lock flood :* *"..settings.flood.."*\n*Lock spam :* *"..settings.lock_spam.."*\n*Lock mention :* *"..settings.lock_mention.."*\n*Lock webpage :* *"..settings.lock_webpage.."*\n*Lock markdown :* *"..settings.lock_markdown.."*\n*Bots protection :* *"..settings.lock_bots.."*\n*Flood sensitivity :* *"..NUM_MSG_MAX.."*\n*____________________*\n*Bot channel*: @NationalTM\n*Group Language* : *EN*"
else
local settings = data[tostring(target)]["settings"] 
 text = "*تنظیمات گروه:*\n*قفل ویرایش پیام :* *"..settings.lock_edit.."*\n*قفل لینک :* *"..settings.lock_link.."*\n*قفل تگ :* *"..settings.lock_tag.."*\n*قفل پیام مکرر :* *"..settings.flood.."*\n*قفل هرزنامه :* *"..settings.lock_spam.."*\n*قفل فراخوانی :* *"..settings.lock_mention.."*\n*قفل صفحات وب :* *"..settings.lock_webpage.."*\n*قفل فونت :* *"..settings.lock_markdown.."*\n*محافظت در برابر ربات ها :* *"..settings.lock_bots.."*\n*حداکثر پیام مکرر :* *"..NUM_MSG_MAX.."*\n*____________________*\n*Bot channel*: @NationalTM\n*زبان سوپرگروه* : *FA*"
end
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "*You're Not Moderator*" 
else
return "*شما مدیر گروه نمیباشید*"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "*Mute All Is Already Enabled*" 
elseif lang then
return "*قفل چت فعال*"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Enabled_" 
else
return "بیصدا کردن همه فعال شد"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "*You're Not Moderator*" 
else
return "*شما مدیر گروه نمیباشید*"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "*Mute All Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن همه غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All Has Been Disabled*" 
else
return "*بیصدا کردن همه غیر فعال شد*"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "*Mute Gif Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن تصاویر متحرک فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "*Mute Gif Has Been Enabled*"
else
 return "*بیصدا کردن تصاویر متحرک فعال شد*"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "*Mute Gif Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن تصاویر متحرک غیر فعال بود*"
end
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Gif Has Been Disabled*" 
else
return "*بیصدا کردن تصاویر متحرک غیر فعال شد*"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
if not lang then
 return "*Mute Game Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن بازی های تحت وب فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Game Has Been Enabled*"
else
 return "*بیصدا کردن بازی های تحت وب فعال شد*"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end 
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
if not lang then
return "*Mute Game Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن بازی های تحت وب غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Game Has Been Disabled*" 
else
return "*بیصدا کردن بازی های تحت وب غیر فعال شد*"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
if not lang then
 return "*Mute Inline Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن کیبورد شیشه ای فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Inline Has Been Enabled*"
else
 return "*بیصدا کردن کیبورد شیشه ای فعال شد*"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
if not lang then
return "*Mute Inline Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن کیبورد شیشه ای غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Inline Has Been Disabled*" 
else
return "*بیصدا کردن کیبورد شیشه ای غیر فعال شد*"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید"
end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "*Mute Text Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن متن فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Text Has Been Enabled*"
else
 return "*بیصدا کردن متن فعال شد*"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end 
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
if not lang then
return "*Mute Text Is Already Disabled*"
elseif lang then
return "*بیصدا کردن متن غیر فعال است*" 
end
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Text Has Been Disabled*" 
else
return "*بیصدا کردن متن غیر فعال شد*"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
 return "*Mute Photo Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن عکس فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Photo Has Been Enabled*"
else
 return "*بیصدا کردن عکس فعال شد*"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
return "*Mute Photo Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن عکس غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Photo Has Been Disabled*" 
else
return "*بیصدا کردن عکس غیر فعال شد*"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "*Mute Video Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن فیلم فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mute Video*Has Been Enabled*"
else
 return "*بیصدا کردن عکس فعال شد*"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "*Mute Video Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن فیلم غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Video Has Been Disabled*" 
else
return "بیصدا کردن فیلم غیر فعال شد"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "*Mute Audio Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن آهنگ فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Audio Has Been Enabled*"
else 
return "*بیصدا کردن آهنگ فعال شد*"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "*Mute Audio Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن آهنک غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Audio Has Been Disabled*"
else
return "*بیصدا کردن آهنگ غیر فعال شد*" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "*Mute Voice Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن صدا فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Voice Has Been Enabled*"
else
 return "*بیصدا کردن صدا فعال شد*"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "*Mute Voice s Already Disabled*" 
elseif lang then
return "*بیصدا کردن صدا غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Voice Has Been Disabled*" 
else
return "*بیصدا کردن صدا غیر فعال شد*"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "*Mute Sticker Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن برچسب فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Sticker Has Been Enabled*"
else
 return "*بیصدا کردن برچسب فعال شد*"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end 
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "*Mute Sticker Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن برچسب غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Sticker Has Been Disabled*"
else
return "*بیصدا کردن برچسب غیر فعال شد*"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "*Mute Contact Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن مخاطب فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Contact Has Been Enabled*"
else
 return "*بیصدا کردن مخاطب فعال شد*"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "*Mute Contact Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن مخاطب غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Contact Has Been Disabled*" 
else
return "*بیصدا کردن مخاطب غیر فعال شد*"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "*Mute Forward Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن نقل قول فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Forward Has Been Enabled*"
else
 return "*بیصدا کردن نقل قول فعال شد*"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "*Mute Forward Is Already Disabled*"
elseif lang then
return "*بیصدا کردن نقل قول غیر فعال است*"
end 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Forward Has Been Disabled*" 
else
return "*بیصدا کردن نقل قول غیر فعال شد*"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "*Mute Location Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن موقعیت فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "*Mute Location Has Been Enabled*"
else
 return "بیصدا کردن موقعیت فعال شد*"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "*Mute Location Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن موقعیت غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Location Has Been Disabled*" 
else
return "*بیصدا کردن موقعیت غیر فعال شد*"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "*Mute Document Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن اسناد فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Document Has Been Enabled*"
else
 return "*بیصدا کردن اسناد فعال شد*"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نمیباشید*"
end
end 

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "*Mute Document Is Already Disabled*" 
elseif lang then
return "*بیصدا کردن اسناد غیر فعال است*"
end
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Document Has Been Disabled*" 
else
return "*بیصدا کردن اسناد غیر فعال شد*"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "*You're Not Moderator*"
else
 return "*شما مدیر گروه نمیباشید*"
end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "*Mute TgService Is Already Enabled*"
elseif lang then
 return "*بیصدا کردن خدمات تلگرام فعال است*"
end
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute TgService Has Been Enabled*"
else
return "*بیصدا کردن خدمات تلگرام فعال شد*"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "*You're Not Moderator*"
else
return "*شما مدیر گروه نیستید*"
end 
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "*Mute TgService Is Already Disabled*"
elseif lang then
return "*بیصدا کردن خدمات تلگرام غیر فعال است*"
end 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute TgService Has Been Disabled*"
else
return "*بیصدا کردن خدمات تلگرام غیر فعال شد*"
end 
end
end
----------MuteList---------
local function mutes(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "*You're Not Moderator*"	
else
 return "*شما مدیر گروه نیستید*"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end

if not lang then
local mutes = data[tostring(target)]["mutes"] 
 text = " *Group Mute List* : \n*Mute all : * *"..mutes.mute_all.."*\n*Mute gif :* *"..mutes.mute_gif.."*\n*Mute text :* *"..mutes.mute_text.."*\n*Mute inline :* *"..mutes.mute_inline.."*\n*Mute game :* *"..mutes.mute_game.."*\n*Mute photo :* *"..mutes.mute_photo.."*\n*Mute video :* *"..mutes.mute_video.."*\n*Mute audio :* *"..mutes.mute_audio.."*\n*Mute voice :* *"..mutes.mute_voice.."*\n_Mute sticker :* *"..mutes.mute_sticker.."*\n*Mute contact :* *"..mutes.mute_contact.."*\n*Mute forward :* *"..mutes.mute_forward.."*\n*Mute location :* *"..mutes.mute_location.."*\n*Mute document :* *"..mutes.mute_document.."*\n*Mute TgService :* *"..mutes.mute_tgservice.."*\n*____________________*\n*Bot channel*: @NationalTM\n*Group Language* : *EN*"       
else
local mutes = data[tostring(target)]["mutes"] 
 text = " *لیست بیصدا ها* : \n*بیصدا همه : * *"..mutes.mute_all.."*\n*بیصدا تصاویر متحرک :* *"..mutes.mute_gif.."*\n*بیصدا متن :* *"..mutes.mute_text.."*\n*بیصدا کیبورد شیشه ای :* *"..mutes.mute_inline.."*\n*بیصدا بازی های تحت وب :* *"..mutes.mute_game.."*\n*بیصدا عکس :* *"..mutes.mute_photo.."*\n*بیصدا فیلم :* *"..mutes.mute_video.."*\n*بیصدا آهنگ :* *"..mutes.mute_audio.."*\n*بیصدا صدا :* *"..mutes.mute_voice.."*\n*بیصدا برچسب :* *"..mutes.mute_sticker.."*\n*بیصدا مخاطب :* *"..mutes.mute_contact.."*\n*بیصدا نقل قول :* *"..mutes.mute_forward.."*\n*بیصدا موقعیت :* *"..mutes.mute_location.."*\n*بیصدا اسناد :* *"..mutes.mute_document.."*\n*بیصدا خدمات تلگرام :* *"..mutes.mute_tgservice.."*\n*____________________*\n*Bot channel*: @NationalTM\n*بان سوپرگروه* : *FA*"
end
return text
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
if matches[1] == "id" then
if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   if not lang then
return "*Chat ID :* *"..chat.."*\n*User ID :* *"..user.."*"
   else
return "*شناسه گروه :* *"..chat.."*\n*شناسه شما :* *"..user.."*"
   end
end
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="id"})
  end
if matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="id"})
      end
   end
if matches[1] == "pin" and is_owner(msg) then
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
if not lang then
return "*Message Has Been Pinned*"
else
return "*پیام سجاق شد*"
end
end
if matches[1] == 'unpin' and is_mod(msg) then
tdcli.unpinChannelMessage(msg.chat_id_)
if not lang then
return "*Pin message has been unpinned*"
else
return "*پیام سنجاق شده پاک شد*"
end
end
if matches[1] == "add" then
return modadd(msg)
end
if matches[1] == "rem" then
return modrem(msg)
end
if matches[1] == "setowner" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "remowner" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "promote" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "demote" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="demote"})
      end
   end

if matches[1] == "lock" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "link" then
return lock_link(msg, data, target)
end
if matches[2] == "tag" then
return lock_tag(msg, data, target)
end
if matches[2] == "mention" then
return lock_mention(msg, data, target)
end
if matches[2] == "edit" then
return lock_edit(msg, data, target)
end
if matches[2] == "spam" then
return lock_spam(msg, data, target)
end
if matches[2] == "flood" then
return lock_flood(msg, data, target)
end
if matches[2] == "bots" then
return lock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return lock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return lock_webpage(msg, data, target)
end
end

if matches[1] == "unlock" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "link" then
return unlock_link(msg, data, target)
end
if matches[2] == "tag" then
return unlock_tag(msg, data, target)
end
if matches[2] == "mention" then
return unlock_mention(msg, data, target)
end
if matches[2] == "edit" then
return unlock_edit(msg, data, target)
end
if matches[2] == "spam" then
return unlock_spam(msg, data, target)
end
if matches[2] == "flood" then
return unlock_flood(msg, data, target)
end
if matches[2] == "bots" then
return unlock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return unlock_webpage(msg, data, target)
end
end
if matches[1] == "mute" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
return mute_all(msg, data, target)
end
if matches[2] == "gif" then
return mute_gif(msg, data, target)
end
if matches[2] == "text" then
return mute_text(msg ,data, target)
end
if matches[2] == "photo" then
return mute_photo(msg ,data, target)
end
if matches[2] == "video" then
return mute_video(msg ,data, target)
end
if matches[2] == "audio" then
return mute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return mute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return mute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return mute_forward(msg ,data, target)
end
if matches[2] == "location" then
return mute_location(msg ,data, target)
end
if matches[2] == "document" then
return mute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return mute_inline(msg ,data, target)
end
if matches[2] == "game" then
return mute_game(msg ,data, target)
end
end

if matches[1] == "unmute" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
return unmute_all(msg, data, target)
end
if matches[2] == "gif" then
return unmute_gif(msg, data, target)
end
if matches[2] == "text" then
return unmute_text(msg, data, target)
end
if matches[2] == "photo" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "video" then
return unmute_video(msg ,data, target)
end
if matches[2] == "audio" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "location" then
return unmute_location(msg ,data, target)
end
if matches[2] == "document" then
return unmute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "game" then
return unmute_game(msg ,data, target)
end
end
if matches[1] == "gpinfo" and is_mod(msg) and gp_type(msg.chat_id_) == "channel" then
local function group_info(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not lang then
ginfo = "*Group Info :*\n*Admin Count :* *"..data.administrator_count_.."*\n*Member Count :* *"..data.member_count_.."*\n*Kicked Count :* *"..data.kicked_count_.."*\n*Group ID :* *"..data.channel_.id_.."*"
print(serpent.block(data))
elseif lang then
ginfo = "*اطلاعات گروه :*\n*تعداد مدیران :* *"..data.administrator_count_.."*\n*تعداد اعضا :* *"..data.member_count_.."*\n*تعداد اعضای حذف شده :* *"..data.kicked_count_.."*\n*شناسه گروه :* *"..data.channel_.id_.."*"
print(serpent.block(data))
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.chat_id_, group_info, {chat_id=msg.chat_id_,msg_id=msg.id_})
end
		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
      if not lang then
			return '*Please send the new link now*'
    else 
         return '*لطفا لینک گروه خود را ارسال کنید*'
       end
		end

		if msg.content_.text_ then
   local is_link = msg.content_.text_:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.content_.text_:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.content_.text_
				save_data(_config.moderation.data, data)
            if not lang then
				return "*Newlink has been set*"
           else
           return "*لینک جدید ذخیره شد*"
		 	end
       end
		end
    if matches[1] == 'link' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "*First set a link for group with using* /setlink"
     else
        return "*اول لینک گروه خود را ذخیره کنید با* /setlink"
      end
      end
     if not lang then
       text = "<b>Group Link :</b>\n"..linkgp
     else
      text = "<b>لینک گروه :</b>\n"..linkgp
         end
        return tdcli.sendMessage(chat, msg.id_, 1, text, 1, 'html')
     end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "*Group rules* _has been set_"
   else 
  return "*قوانین گروه ثبت شد*"
   end
  end
  if matches[1] == "rules" then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@NationalTM"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@NationalTM"
 end
        else
     rules = "*Group Rules :*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "res" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="res"})
  end
if matches[1] == "whois" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'setflood' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "*Wrong number, range is* *[1-50]*"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'clean' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(chat)]['mods']) == nil then
            if not lang then
					return "_No_ *moderators* _in this group_"
             else
                return "*هیچ مدیری برای گروه انتخاب نشده است*"
				end
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *moderators* _has been demoted_"
          else
            return "*تمام مدیران گروه تنزیل مقام شدند*"
			end
         end
			if matches[2] == 'rules' then
				if not data[tostring(chat)]['rules'] then
            if not lang then
					return "_No_ *rules* _available_"
             else
               return "*قوانین برای گروه ثبت نشده است*"
             end
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Group rules* _has been cleaned_"
          else
            return "*قوانین گروه پاک شد*"
			end
       end
			if matches[2] == 'about' then
        if gp_type(chat) == "chat" then
				if not data[tostring(chat)]['about'] then
            if not lang then
					return "_No_ *description* _available_"
            else
              return "*پیامی مبنی بر درباره گروه ثبت نشده است*"
          end
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
             if not lang then
				return "*Group description* _has been cleaned_"
           else
              return "*پیام مبنی بر درباره گروه پاک شد*"
             end
		   	end
        end
		if matches[1]:lower() == 'clean' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(chat)]['owners']) == nil then
             if not lang then
					return "_No_ *owners* _in this group_"
            else
                return "*مالکی برای گروه انتخاب نشده است*"
            end
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *owners* _has been demoted_"
           else
            return "*تمامی مالکان گروه تنزیل مقام شدند*"
          end
			end
     end
if matches[1] == "setname" and matches[2] and is_mod(msg) then
local gp_name = string.gsub(matches[2], "_","")
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
     if gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif gp_type(chat) == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "*Group description* _has been set_"
    else
     return "*پیام مبنی بر درباره گروه ثبت شد*"
      end
  end
  if matches[1] == "about" and gp_type(chat) == "chat" then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "*پیامی مبنی بر درباره گروه ثبت نشده است*"
       end
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "settings" then
return group_settings(msg, target)
end
if matches[1] == "mutelist" then
return mutes(msg, target)
end
if matches[1] == "modlist" then
return modlist(msg)
end
if matches[1] == "ownerlist" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "setlang" and is_owner(msg) then
   if matches[2] == "en" then
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 redis:del(hash)
return "_Group Language Set To:_ EN"
  elseif matches[2] == "fa" then
redis:set(hash, true)
return "*زبان گروه تنظیم شد به : فارسی*"
end
end

if matches[1] == "help" and is_mod(msg) then
if not lang then
text = [[
*BomBusMod Bot Commands:*

*!setowner* *[username|id|reply]* 
*!remowner*  
*!promote*  
*!demote*  
*!setflood* *[1-50]*
*!silent*  
*!unsilent*  
*!kick*  
*!ban*  
*!unban*  
*!res* *[username]*
*!whois* *[id]*
*!lock* *[link | tag | edit | webpage | bots | spam | flood | markdown | mention | fosh]*
*!unlock* *[link | tag | edit | webpage | bots | spam | flood | markdown | mention| fosh]*
*!mute* *[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]*
*!unmute* *[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]*
*!set**[rules | name | photo | link | about]*
*!clean* *[bans | mods | bots | rules | about | silentlist]*   
*!pin* *[reply]*
*!unpin* 
*!settings*
*!mutelist*
*!silentlist*
*!banlist*
*!ownerlist*
*!modlist* 
*!rules*
*!about*
*!gpinfo*
*!link*
*setexpire (1) & expire *
*!filter (world)*
*!unfilter*
*!filterlist*
*!mt (1)(1) &  !unmt*   
_lock time expire_

*You Can Use [!/#] To Run The Commands*

*Natonall Managers*]]

elseif lang then

text = [[
*دستورات ربات بومباس:*
*!setowner* *[username|id|reply]* 
*انتخاب مالک گروه(قابل انتخاب چند مالک)*

*!remowner* 
 *حذف کردن فرد از فهرست مالکان گروه*
*!promote*  
*ارتقا مقام کاربر به مدیر گروه*
*!demote*  
*تنزیل مقام مدیر به کاربر*
*!setflood* *[1-50]*
*تنظیم حداکثر تعداد پیام مکرر*
*!silent*  
*بیصدا کردن کاربر در گروه*
*!unsilent*  
*در آوردن کاربر از حالت بیصدا در گروه*
*!kick*  
*حذف کاربر از گروه*
*!ban*  
*مسدود کردن کاربر از گروه*
*!unban*  
*در آوردن از حالت مسدودیت کاربر از گروه*
*!res* *[username]*
*نمایش شناسه کاربر*
*!whois* *[id]*
*نمایش نام کاربر, نام کاربری و اطلاعات حساب*

*!lock* *[link | tag | edit | webpage | bots | spam | flood | markdown | mention | fosh]*
*در صورت قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد*

*!unlock* *[link | tag | edit | webpage | bots | spam | flood | markdown | mention | fosh]*
*در صورت قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد*

*!mute* *[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]*
*در صورت بیصدد بودن فعالیت ها, ربات آنهارا حذف خواهد کرد*

*!unmute* *[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]*
*در صورت بیصدا نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد*

*!set**[rules | name | photo | link | about]*
*ربات آنهارا ثبت خواهد کرد*

*!clean* *[bans | mods | bots | rules | about | silentlist]*   
*ربات آنهارا پاک خواهد کرد*

*!pin* *[reply]*
*ربات پیام شمارا در گروه سنجاق خواهد کرد*
*!unpin* 
*ربات پیام سنجاق شده در گروه را حذف خواهد کرد*
*!settings*
*نمایش تنظیمات گروه*
*!mutelist*
*نمایش فهرست بیصدا های گروه*
*!silentlist*
*نمایش فهرست افراد بیصدا*
*!banlist*
*نمایش افراد مسدود شده از گروه*
*!ownerlist*
*نمایش فهرست مالکان گروه* 
*!modlist* 
*نمایش فهرست مدیران گروه*
*!rules*
*نمایش قوانین گروه*
*!about*
*نمایش درباره گروه*
*!gpinfo*
*نمایش اطلاعات گروه*
*!link*
*نمایش لینک گروه*
*setexpire (1) & expire *
*زمان دار کردن ربات درگروه*
*!filter (world)*
*فیلترکلمه*
*!unfilter*
*دراوردن کلمه از فیلتر*
*!filterlist*
*کلمات فیلتر شده*
*!mt 1 1 | برای باز کردن >> !unmt*
*قفل چت زمان دار*

*شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید*

*Nationall Managers*]]
end
return text
end
end
return {
patterns ={
"^[!/#](id)$",
"^[!/#](id) (.*)$",
"^[!/#](pin)$",
"^[!/#](unpin)$",
"^[!/#](gpinfo)$",
"^[!/#](test)$",
"^[!/#](add)$",
"^[!/#](rem)$",
"^[!/#](setowner)$",
"^[!/#](setowner) (.*)$",
"^[!/#](remowner)$",
"^[!/#](remowner) (.*)$",
"^[!/#](promote)$",
"^[!/#](promote) (.*)$",
"^[!/#](demote)$",
"^[!/#](demote) (.*)$",
"^[!/#](modlist)$",
"^[!/#](ownerlist)$",
"^[!/#](lock) (.*)$",
"^[!/#](unlock) (.*)$",
"^[!/#](settings)$",
"^[!/#](mutelist)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](link)$",
"^[!/#](setlink)$",
"^[!/#](rules)$",
"^[!/#](setrules) (.*)$",
"^[!/#](about)$",
"^[!/#](setabout) (.*)$",
"^[!/#](setname) (.*)$",
"^[!/#](clean) (.*)$",
"^[!/#](setflood) (%d+)$",
"^[!/#](res) (.*)$",
"^[!/#](whois) (%d+)$",
"^[!/#](help)$",
"^[!/#](setlang) (.*)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
},
run=run
}
--end groupmanager.lua 
