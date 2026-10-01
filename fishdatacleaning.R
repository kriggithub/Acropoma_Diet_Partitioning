### Fish Data Cleaning
### Kurt Riggin
### 21 September 2024



#load in packages & datasets (ignore old data)
library(tidyverse)
#setwd("/cloud/project/GhedottiVossResearch")
ajapdatadj <- read.csv("Ajapdietadj.csv")
ahandatadj <- read.csv("Ahandietadj.csv")
  #ajapdat <- read.csv("Ajapdiet.csv")
  #ahandat <- read.csv("Ahandiet.csv")




#rename columns of interest to match and select them
ajapdatadj <- rename(ajapdatadj, ID = Ind., Month = month, Jar = JFBM, SL = SL..mm., Category = category, Vol = Volume..mm.3.)
ahandatadj <- rename(ahandatadj, ID = Ind., Month = Mo., Jar = JFBM, SL = SL..mm., Category = category, Vol = Volume..mm.3.)
ajapdatadj <- ajapdatadj %>% select(Species, Jar, ID, Month, SL, Category, Vol)
ahandatadj <- select(ahandatadj, Species, Jar, ID, Month, SL, Category, Vol)



#truncate all empty rows (remove observations with no standard length recorded)
ajapdatadj <- ajapdatadj %>% filter(!is.na(SL))
ahandatadj <- ahandatadj %>% filter(!is.na(SL))
  #nrow(ajapdatadj) #85 obs
  #nrow(ahandatadj) #96 obs


ajapmay <- ajapdatadj %>% filter(Month == 2)






#perform checks on variables in data
  #species
table(ajapdatadj$Species) #1 species
table(ahandatadj$Species) #1 species
  #jar
table(ajapdatadj$Jar) #4 jars
table(ahandatadj$Jar) #7 jars
  #IDs (issues resolved)
table(ajapdatadj$ID) #######issues with IDs: parenthesis, unique IDs have multiple SL values
table(ahandatadj$ID)
  #Month
table(ajapdatadj$Month) #Months 2 & 5
table(ahandatadj$Month) #Months 2 & 5
  #SL
table(ajapdatadj$SL) #range 50-126
table(ahandatadj$SL) #range 31-121
  #Category
table(ajapdatadj$Category) #5 categories
table(ahandatadj$Category) #Same categories except mollusk
  #Volume (ranges are plausible)
table(ajapdatadj$Vol) #range 0.004-364
table(ahandatadj$Vol) #range 1-600





#make new column for master jar (MJar)
ajapdatadj<- ajapdatadj %>% 
  mutate(
    MJar = gsub("-.*", "", Jar))
ahandatadj<- ahandatadj %>% 
  mutate(
    MJar = gsub("-.*", "", Jar))
ajapdatadj <- relocate(ajapdatadj, MJar, .after = Species)
ahandatadj <- relocate(ahandatadj, MJar, .after = Species)




#combine Jar and ID to create unique ID (Jar_ID)
ajapdatadj <- unite(ajapdatadj, FishID, Jar, ID)
ahandatadj <- unite(ahandatadj, FishID, Jar, ID)



#check new IDs for fish with multiple measurements (issues resolved)
ajaprepeat <- ajapdatadj %>% 
  group_by(FishID) %>% 
  count() %>% 
  filter(n>1)
ajapmult <- ajapdatadj %>%
  semi_join(ajaprepeat, by = "FishID") 
  #view(ajapmult)#issues with fish from jar 48707: IDs 1-6 have different SL values
ahanrepeat <- ahandatadj %>% 
  group_by(FishID) %>% 
  count() %>% 
  filter(n>1)
ahanmult <- ahandatadj %>%
  semi_join(ahanrepeat, by = "FishID") 
#view(ahanmult)#same issues with fish from jar 49353: IDs from 2-8 have different SL values, different vol values in other jars


#####
#write.csv(ajapmult, file = "Ajap_Multiple.csv")
#write.csv(ahanmult, file = "Ahan_Multiple.csv")
##### Reconcile issues first (resolved)


#bind together data sets and change Months from numeric to name
fishdat1 <- rbind(ajapdatadj, ahandatadj)
fishdat1$Month <- replace(fishdat1$Month, fishdat1$Month == 2, "Feb")
fishdat1$Month <- replace(fishdat1$Month, fishdat1$Month == 5, "May")


#sum items that have multiple content values to get 1 overall volume per category
fishdat1sum <- fishdat1 %>% 
  group_by(Species, MJar, FishID, Month, SL, Category) %>% 
  summarize(Vol = sum(Vol)) %>% 
  ungroup()



#create second table to characterize stomach content
fishdat2 <- fishdat1sum %>% 
  mutate(Vol = ifelse(is.na(Vol), 0, Vol)) %>% 
  pivot_wider(names_from = Category, values_from = Vol, values_fill = 0)
fishdat2 <- select(fishdat2, -none)
fishdat2[is.null(fishdat2)] = 0


#add column to tell if there is stomach content (Content) or not (y/n) onto fishdat2 
  #(0 represents no, 1 represents yes) and column for Size Class (SClass) (1 represents large, 0 represents small, cutoff is 60)
fishdat2 <- fishdat2 %>% 
  mutate(
    Content = ifelse(rowSums(select(., animal, crustacean, fish, mollusk)) == 0, 0, 1)
  )
fishdat2 <- fishdat2 %>% 
  mutate(
    SClass = ifelse(SL >= 60, 1, 0)
  )
fishdat2 <- relocate(fishdat2, SClass, .after = SL)


#Check fishdat2 for all unique IDs and write new files
length(unique(fishdat2$FishID)) #170
  #write.csv(fishdat2, file = "fishdat2.csv")
  #write.csv(fishdat1sum, file = "fishdat1sum.csv")

#write.csv(fishdat1, file = "fishdat1.csv")













