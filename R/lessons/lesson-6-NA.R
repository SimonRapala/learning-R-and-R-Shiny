confidenceScores <- c(1.00, 0.95, NA, 0.87, NA)

print(confidenceScores)
print(is.na(confidenceScores))
print(sum(is.na(confidenceScores)))
print(anyNA(confidenceScores))
print(mean(confidenceScores))
print(mean(confidenceScores, na.rm = TRUE))

print(sum(confidenceScores, na.rm = TRUE))