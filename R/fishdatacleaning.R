### Fish Data Cleaning
### Kurt Riggin
### 21 September 2024



# Load in packages & datasets (adj data separated individual fish with same label)
library(tidyverse)
# setwd("/PATH_HERE")
ajapdata <- read.csv("Ajapdietadj.csv")
ahandata <- read.csv("Ahandietadj.csv")



# Rename columns of interest to match and select them
ajapdata <- ajapdata |>
  select(Species,
         Jar      = JFBM,
         ID       = Ind.,
         Month    = month,
         SL       = SL..mm.,
         Category = category,
         Vol      = Volume..mm.3.)
  
ahandata <- ahandata |>
  select(Species,
         Jar      = JFBM,
         ID       = Ind.,
         Month    = Mo.,
         SL       = SL..mm.,
         Category = category,
         Vol      = Volume..mm.3.)


# Truncate empty rows (remove observations with no standard length recorded)
ajapdata <- ajapdata %>% filter(!is.na(SL))
ahandata <- ahandata %>% filter(!is.na(SL))
  #nrow(ajapdata) #85 obs
  #nrow(ahandata) #96 obs




# Perform checks on variables in data
  #species
table(ajapdata$Species) #1 species
table(ahandata$Species) #1 species
  #jar
table(ajapdata$Jar) #4 jars
table(ahandata$Jar) #7 jars
  #IDs (issues resolved)
table(ajapdata$ID) ####### issues with IDs: parenthesis, unique IDs have multiple SL values
table(ahandata$ID)
  #Month
table(ajapdata$Month) #Months 2 & 5
table(ahandata$Month) #Months 2 & 5
  #SL
table(ajapdata$SL) #range 50-126
table(ahandata$SL) #range 31-121
  #Category
table(ajapdata$Category) #5 categories
table(ahandata$Category) #Same categories except mollusk
  #Volume (ranges are plausible)
table(ajapdata$Vol) #range 0.004-364
table(ahandata$Vol) #range 1-600





# Make new column for master jar to combine subset jars (MJar)
ajapdata<- ajapdata %>% 
  mutate(
    MJar = gsub("-.*", "", Jar))
ahandata<- ahandata %>% 
  mutate(
    MJar = gsub("-.*", "", Jar))
ajapdata <- relocate(ajapdata, MJar, .after = Species)
ahandata <- relocate(ahandata, MJar, .after = Species)




# Combine Jar and ID to create unique ID (Jar_ID)
ajapdata <- unite(ajapdata, FishID, Jar, ID)
ahandata <- unite(ahandata, FishID, Jar, ID)



# Check new IDs for fish with multiple measurements (issues resolved)
ajaprepeat <- ajapdata %>% 
  group_by(FishID) %>% 
  count() %>% 
  filter(n>1)
ajapmult <- ajapdata %>%
  semi_join(ajaprepeat, by = "FishID") 
  #view(ajapmult)
  #issues with fish from jar 48707: IDs 1-6 have different SL values
ahanrepeat <- ahandata %>% 
  group_by(FishID) %>% 
  count() %>% 
  filter(n>1)
ahanmult <- ahandata %>%
  semi_join(ahanrepeat, by = "FishID") 
  #view(ahanmult)
  #same issues with fish from jar 49353: IDs from 2-8 have different SL values, different vol values in other jars


#####
#write.csv(ajapmult, file = "data/Ajap_Multiple.csv")
#write.csv(ahanmult, file = "data/Ahan_Multiple.csv")
##### Reconcile issues first (resolved)


# Bind together data sets and change Months from numeric to name
fish_data_long <- rbind(ajapdata, ahandata)
fish_data_long$Month <- replace(fish_data_long$Month, fish_data_long$Month == 2, "Feb")
fish_data_long$Month <- replace(fish_data_long$Month, fish_data_long$Month == 5, "May")


# Sum items that have multiple content values to get 1 overall volume per category
fish_data_long_summed <- fish_data_long %>% 
  group_by(Species, MJar, FishID, Month, SL, Category) %>% 
  summarize(Vol = sum(Vol)) %>% 
  ungroup()



# Create second table to characterize stomach content (wide)
fish_data_wide <- fish_data_long_summed %>% 
  mutate(Vol = ifelse(is.na(Vol), 0, Vol)) %>% 
  pivot_wider(names_from = Category, values_from = Vol, values_fill = 0)
fish_data_wide <- select(fish_data_wide, -none)
fish_data_wide[is.null(fish_data_wide)] = 0


# Add column to tell if there is stomach content (Content) or not (y/n) onto fish_data_wide (0 represents no, 1 represents yes) and 
# column for Size Class (SClass) (1 represents large, 0 represents small, cutoff is 60)
fish_data_wide <- fish_data_wide %>% 
  mutate(
    Content = ifelse(rowSums(select(., animal, crustacean, fish, mollusk)) == 0, 0, 1)
  )
fish_data_wide <- fish_data_wide %>% 
  mutate(
    SClass = ifelse(SL >= 60, 1, 0)
  )
fish_data_wide <- relocate(fish_data_wide, SClass, .after = SL)


# Check fish_data_wide for all unique IDs and write new files
length(unique(fish_data_wide$FishID)) #170


# write.csv(fish_data_wide, file = "fish_data_wide.csv")
# write.csv(fish_data_long_summed, file = "fish_data_long_summed.csv")
# write.csv(fish_data_long, file = "fish_data_long.csv")













