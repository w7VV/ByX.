-- Simple Memory Bytecode Dumper for Delta (Extract Injected/Obfuscated Scripts)

local function dumpMemoryScripts()
    print("[Memory Dumper] بدء سحب السكربتات من الذاكرة... (getgc)")

    local count = 0
    for _, obj in getgc(true) do
        if typeof(obj) == "function" and islclosure(obj) then  -- C closures فقط (السكربتات الحقيقية)
            local bytecode = getscriptbytecode(obj)
            if bytecode and #bytecode > 100 then  -- تجاهل الصغيرة عشان ما تملأ
                count += 1
                local fileName = "Dumped_Script_" .. count .. ".luac"  -- bytecode خام
                if writefile then
                    writefile(fileName, bytecode)
                    print("[Memory Dumper] تم حفظ: " .. fileName .. " (حجم: " .. #bytecode .. " bytes)")
                else
                    print("[Memory Dumper] bytecode لسكربت " .. count .. ":\n" .. bytecode:sub(1, 500) .. "... (اقتصرته)")
                end
            end
        end
    end

    print("[Memory Dumper] خلص! تم العثور على " .. count .. " سكربت محتمل. روح مجلد workspace شوف الملفات .luac")
    print("[Memory Dumper] استخدم deobfuscator خارجي (زي online Luau decompilers) عشان تحول الـ .luac لكود قابل قراءة")
end

spawn(dumpMemoryScript)  -- يشتغل فورًا
