# Лабораторна робота № 5. Отримання та очистка даних


##Ви повинні створити один R-скрипт, який називається run_analysis.R, який виконує наступні дії.

## 1. Об’єднує навчальний та тестовий набори, щоб створити один набір даних.
## 2. Витягує лише вимірювання середнього значення та стандартного відхилення (mean and standard deviation) для кожного вимірювання.
## 3. Використовує описові назви діяльностей (activity) для найменування діяльностей у наборі даних.
## 4. Відповідно присвоює змінним у наборі даних описові імена.
## 5. З набору даних з кроку 4 створити другий незалежний акуратний набір даних (tidy dataset) із середнім значенням для кожної змінної для кожної діяльності та кожного суб’єкту (subject).

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Завантажуємо  мітки активності
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Назви стовбців
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Залишаємо лише середнє значення та стандартне відхилення
extract_features <- grepl("mean|std", features)

# Завантажуємо X_test та y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Залишаємо лише середнє значення та стандартне відхилення
X_test = X_test[,extract_features]

#Завантажуємо  мітки активності
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Об'єднуємо дані
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Завантажуємо X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Залишаємо лише середнє значення та стандартне відхилення
X_train = X_train[,extract_features]

#Завантажуємо  мітки активності
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Об'єднуємо дані
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Об'єднуємо тестові та тренувальні дані:
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Застосовуємо mean функцію до набору даних за допомогою функції dcast
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")