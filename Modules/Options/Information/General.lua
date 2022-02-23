local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:General()
    local options = self.options.information.args.general.args

    -- Reset order for new page
    self:ResetOrder()

    -- Welcome Description
    options["generalWelcome"] = {
        order = self:GetOrder(),
        inline = true,
        type = "group",
        name = "Description",
        args = {
            ["generalWelcomeDesc"] = {
                order = self:GetOrder(),
                type = "description",
                name = TXUI.Title .. " is a minimalistic " .. F.StringElvUI("ElvUI") .. " edit by " ..
                    F.StringToxiUI("Toxi") ..
                    " best suited for 1440p resolution. \nIt is designed to be used along with " ..
                    F.StringLuxthos("Luxthos") .. " WeakAuras."
            }
        }
    }

    -- Spacer
    self:AddSpacer(options)

    -- Installation/Update/Reset
    options["generalInstall"] = {
        order = self:GetOrder(),
        inline = true,
        type = "group",
        name = "Installation guide",
        args = {
            -- Welcome Description
            ["generalInstallDesc"] = {
                order = self:GetOrder(),
                type = "description",
                name = "The installation guide should pop up automatically after you login." ..
                    " \nIf you wish to re-run the installation process to update some settings please click the " ..
                    F.StringToxiUI("INSTALL/UPDATE") .. " button below.\n\n"
            },

            -- Install BUTTON
            ["generalInstallButton"] = {
                order = self:GetOrder(),
                type = "execute",
                name = F.StringToxiUI("INSTALL/UPDATE"),
                desc = "Run the installation/update process.",
                func = function()
                    E:GetModule("PluginInstaller"):Queue(TXUI:GetModule("Installer"):Dialog())
                    E:ToggleOptionsUI()
                end
            }
        }
    }

    -- Spacer
    self:AddSpacer(options)

    -- Credits
    local credits = ""

    -- Credits helpers
    local addToCredits = function(hex, name)
        credits = credits .. "|cff" .. hex .. name .. "|r\n"
    end

    -- Add to credit
    addToCredits("f2d705", "Hekili")
    addToCredits("0050db", "v0dKa")
    addToCredits("ff7c0a", "eaglegoboom")
    addToCredits("a96dad", "Rhapsody")
    addToCredits("ff7c0a", "Releaf")
    addToCredits("e64337", "Redtuzk & his crew")
    addToCredits("5cfa4b", "Darth Predator & Repooc")
    addToCredits("cc0e00", "Gennoken")
    addToCredits("ff99f2", "Jeor")
    addToCredits("561c75", "Nalar")
    addToCredits("0070de", "Rai")
    addToCredits("ff0066", "Franny")

    -- Credits Group
    options["generalCredits"] = {
        order = self:GetOrder(),
        inline = true,
        type = "group",
        name = "Credits",
        args = {
            -- Credits Header
            ["generalCreditsDesc1"] = {
                order = self:GetOrder(),
                type = "description",
                name = "Special thanks goes to these amazing people for their help, code or inspiration.\n\n"
            },

            -- Credits Text
            ["generalCreditsDesc2"] = { order = self:GetOrder(), type = "description", name = credits },

            -- Credits Footer
            ["generalCreditsDesc3"] = {
                order = self:GetOrder(),
                type = "description",
                name = "\nand all the PayPal & Patreon supporters!"
            }
        }
    }

    -- Spacer
    self:AddSpacer(options)

    -- Credits
    options["generalContact"] = {
        order = self:GetOrder(),
        inline = true,
        type = "group",
        name = "Contacts",
        args = {
            -- Discord URL
            ["generalContactDiscord"] = {
                order = self:GetOrder(),
                type = "input",
                width = "full",
                name = "Join Discord for support!",
                get = function()
                    return TXUI.Links.DiscordToxi
                end
            },

            -- Spacer
            ["generalContactSpacer"] = { order = self:GetOrder(), type = "description", name = " " },

            -- Discord Logo
            ["generalContactDiscordIcon"] = {
                order = self:GetOrder(),
                type = "description",
                name = "",
                image = function()
                    return I.Media.Logos.Discord, 256, 64
                end
            }
        }
    }
end

O:AddCallback("General")
