Analytics = class()

ANALYTICS_URL = "http://www.google-analytics.com/collect"

function Analytics:init(trackingId, appName)
    self.tid = trackingId
    self.an = appName
    self.aid = bundleId
    if isNative() then
        self.cid = native.getIdentifierForVendor()
        self.av = native.getBundleVersion() .. "_" .. native.getBuildVersion()
        self.aid = native.getBundleId()
    else
        self.cid = "debugCid"
        self.av = "debugAv"
        self.aid = "debugAid"
    end
end

function Analytics:event(category, action, label)
    parameters = {}
    parameters["method"] = "POST"
    parameters["data"] = 
        "v=1&t=event" ..
        "&tid=" .. self.tid .. 
        "&cid=" .. self.cid ..
        "&av=" .. self.av ..
        "&an=" .. self.an ..
        "&aid=" .. self.aid ..
        "&ec=" .. category ..
        "&ea=" .. action ..
        "&el=" .. label
    http.request(
        ANALYTICS_URL,
        AnalyticsSuccess,
        AnalyticsFail,
        parameters)
end

function Analytics:view(name)
    parameters = {}
    parameters["method"] = "POST"
    parameters["data"] = 
        "v=1&t=screenview" ..
        "&tid=" .. self.tid .. 
        "&cid=" .. self.cid ..
        "&av=" .. self.av ..
        "&an=" .. self.an ..
        "&aid=" .. self.aid ..
        "&cd=" .. name
    http.request(
        ANALYTICS_URL,
        AnalyticsSuccess,
        AnalyticsFail,
        parameters)
end

function AnalyticsSuccess(data, status, headers) 
end

function AnalyticsFail(error)
end
