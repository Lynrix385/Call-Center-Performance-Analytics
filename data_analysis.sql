-- Escalation Rate per Month
SELECT 
    FORMAT(CallDate, 'yyyy-MM') AS Month,
    COUNT(*) AS TotalCalls,
    COUNT(CASE WHEN ResolutionStatus = 'Escalated' THEN 1 END) AS EscalatedCalls,
    ROUND(CAST(COUNT(CASE WHEN ResolutionStatus = 'Escalated' THEN 1 END) AS FLOAT) 
          / COUNT(*) * 100, 2) AS EscalationRate_Percentage
FROM Calls
GROUP BY FORMAT(CallDate, 'yyyy-MM')
ORDER BY Month;

-- Agent Performance
SELECT 
    a.AgentName,
    COUNT(c.CallID) AS TotalCallsHandled,
    ROUND(AVG(CAST(c.SatisfactionScore AS FLOAT)), 2) AS AvgSatisfaction,
    COUNT(CASE WHEN c.ResolutionStatus = 'Escalated' THEN 1 END) AS TotalEscalations
FROM Agents a
JOIN Calls c ON a.AgentID = c.AgentID
GROUP BY a.AgentName
ORDER BY TotalCallsHandled DESC;

-- Channel Analysis
SELECT 
    Channel,
    COUNT(*) AS TotalCalls,
    AVG(WaitTimeSec) AS AvgWaitTime,
    ROUND(AVG(CAST(SatisfactionScore AS FLOAT)), 2) AS AvgSatisfaction
FROM Calls
GROUP BY Channel
ORDER BY AvgSatisfaction DESC;