M = {}

M.options = {}

local defaults = {notes_directory = os.getenv("HOME") .. "/notes"}

M.new = function()
    local title = ""
    local raw_tags = ""
    local tags = {}

    vim.ui.input({prompt = "Enter title: "}, function(input) title = input end)
    if title == nil then
        print("The title is required.")
        return
    end
    title = title.gsub(title, "%s+$", "")

    vim.ui.input({prompt = "Enter tags (comma separated): "},
                 function(input) raw_tags = input end)

    if raw_tags ~= nil then
        for i in string.gmatch(raw_tags, "([^%s*,%s*]+)") do
            table.insert(tags, i)
        end
    end

    M._open(title, tags)
end

M._open = function(name, tags)
    local date_prefix = os.date("%Y-%m-%d")

    local normalized_name = string.lower(name)
    normalized_name = string.gsub(normalized_name, "%s+", "-")

    local file_tags = table.concat(tags, "_")
    local postfix = ""
    if file_tags ~= "" then postfix = "__" .. file_tags end

    local file_name = date_prefix .. "--" .. normalized_name .. postfix .. ".md"
    vim.cmd("e " .. M.options.notes_directory .. "/" .. file_name)
    vim.api.nvim_put({"# " .. name}, "l", false, true)
end

M.setup = function(opts)
    M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

return M
