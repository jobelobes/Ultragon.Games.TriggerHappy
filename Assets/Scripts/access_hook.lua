-- access_hook.lua

local access = {public = 0, protected = 1, private = 2}

function preparse_hook(p)
	-- we need to make all structs 'public' by default
	p.code = string.gsub(p.code, "(struct[^;]*{)", "%1\npublic:\n")
	p.code = string.gsub(p.code, "String ", "std::string ")
end


function parser_hook(s)

        local container = classContainer.curr -- get the current container
        if not container.curr_member_access and container.classtype == 'class' then
			-- default access for classes is private
			container.curr_member_access = access.private
        end

        -- try labels (public, private, etc)
        do
			local b,e,label = string.find(s, "^%s*(%w*)%s*:[^:]") -- we need to check for [^:], otherwise it would match 'namespace::type'
			if b then
				-- found a label, get the new access value from the global 'access' table
				if access[label] then
						container.curr_member_access = access[label]
				end -- else ?

				return strsub(s, e) -- normally we would use 'e+1', but we need to preserve the [^:]
			end
        end
		
		-- try labels (public, private, etc)
        do
			local b,e,label = string.find(s, "^friend%s+class%s+.*%s+") -- we need to check for [^:], otherwise it would match 'namespace::type'
			if b then
				return strsub(s, e + 1) -- normally we would use 'e+1', but we need to preserve the [^:]
			end
        end

end