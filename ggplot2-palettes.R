
library(tidyverse)

## NineteenEightyR
# remotes::install_github("m-clark/NineteenEightyR") 

chickwts |>  
  ggplot(aes(x = feed)) +
  geom_point(aes(y = weight, colour = feed), position = position_jitter(width = .13), size = 0.5, alpha = 0.6) +
  see::geom_violinhalf(aes(y = weight, alpha = 0.3, fill = feed), linetype = "dashed", position = position_nudge(x = .2)) +
  geom_boxplot(aes(y = weight, alpha = 0.3, colour = feed), position = position_nudge(x = -.1), width = 0.1, outlier.shape = NA) +
  scale_fill_manual(values = NineteenEightyR::electronic_night(n = 6)) +
  scale_colour_manual(values = NineteenEightyR::electronic_night(n = 6)) +
  theme_classic() +
  labs(x = "Feed Type", y = "Weight (g)") +
  theme(legend.position = "none") +
  coord_flip()


## LaCroixColoR
# devtools::install_github("johannesbjork/LaCroixColoR")

# colour must be a factor
mpg %>% 
  ggplot(aes(x = cty, y = hwy, colour = as.factor(hwy))) +
  geom_point()  +
  scale_colour_manual(values = LaCroixColoR::lacroix_palette("PeachPear", type = "continuous", n = 27))
