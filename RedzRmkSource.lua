-- Remaked Version of Redz ui lib Made By TojiButSans in discord
local UILibrary = {}

function UILibrary:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local Sidebar = Instance.new("Frame")
    local Container = Instance.new("Frame")

    -- UI Properties
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Parent = ScreenGui

    -- Top Bar
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.Parent = MainFrame

    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.Parent = TopBar

    -- Sidebar
    Sidebar.Size = UDim2.new(0, 120, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Sidebar.Parent = MainFrame

    -- Main Container for Tabs
    Container.Size = UDim2.new(1, -120, 1, -30)
    Container.Position = UDim2.new(0, 120, 0, 30)
    Container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Container.Parent = MainFrame

    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local TabFrame = Instance.new("Frame")

        -- Tab Button in Sidebar
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, (#Sidebar:GetChildren() - 1) * 45)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabButton.Parent = Sidebar

        -- Tab Content Area
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabFrame.Visible = false
        TabFrame.Parent = Container

        -- Switching Tabs
        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("Frame") then child.Visible = false end
            end
            TabFrame.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 250, 0, 40)
            Button.Position = UDim2.new(0, 10, 0, #TabFrame:GetChildren() * 50)
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Parent = TabFrame

            Button.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateToggle(text, callback)
            local Toggle = Instance.new("TextButton")
            local Enabled = false

            Toggle.Size = UDim2.new(0, 250, 0, 40)
            Toggle.Position = UDim2.new(0, 10, 0, #TabFrame:GetChildren() * 50)
            Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Toggle.Text = text .. " [OFF]"
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.Parent = TabFrame

            Toggle.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Toggle.Text = text .. (Enabled and " [ON]" or " [OFF]")
                callback(Enabled)
            end)
        end

        function Elements:CreateSlider(text, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            local SliderBar = Instance.new("Frame")
            local SliderButton = Instance.new("TextButton")
            local ValueText = Instance.new("TextLabel")

            SliderFrame.Size = UDim2.new(0, 250, 0, 40)
            SliderFrame.Position = UDim2.new(0, 10, 0, #TabFrame:GetChildren() * 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderFrame.Parent = TabFrame

            ValueText.Size = UDim2.new(1, 0, 0.5, 0)
            ValueText.Position = UDim2.new(0, 0, 0, 0)
            ValueText.Text = text .. ": " .. min
            ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueText.Parent = SliderFrame

            SliderBar.Size = UDim2.new(1, -10, 0.3, 0)
            SliderBar.Position = UDim2.new(0, 5, 0.7, 0)
            SliderBar.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            SliderBar.Parent = SliderFrame

            SliderButton.Size = UDim2.new(0, 20, 1, 0)
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar

            local dragging = false
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            game:GetService("RunService").RenderStepped:Connect(function()
                if dragging then
                    local Mouse = game.Players.LocalPlayer:GetMouse()
                    local X = math.clamp((Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local NewValue = math.floor(min + (max - min) * X)
                    ValueText.Text = text .. ": " .. NewValue
                    SliderButton.Position = UDim2.new(X, -10, 0, 0)
                    callback(NewValue)
                end
            end)
        end

        return Elements
    end

    return Tabs
end
