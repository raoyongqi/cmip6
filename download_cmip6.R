# install.packages("remotes")
# detach("package:geodata", unload = TRUE)
# 
# remove.packages("geodata")
library(remotes)

# remotes::install_github("rspatial/geodata")
library(geodata)
getwd()
setwd("C:/Users/r/Desktop/cmip6")
# 设置模型、情景和变量
# install.packages("remotes")
# detach("package:geodata", unload = TRUE)
# remove.packages("geodata")
library(remotes)

# 从 GitHub 安装 geodata 包
# remotes::install_github("rspatial/geodata")
library(geodata)

# 设置工作目录
setwd("C:/Users/r/Desktop/cmip6")
models <- c("ACCESS-CM2")  # 这里只放一个模型
scenarios <- c("126", "245", "370", "585")
variables <- c("tmin", "tmax", "prec", "bioc")  # 更新为需要下载的变量
time_ranges <- c("2021-2040", "2041-2060", "2061-2080", "2081-2100")  # 时间范围
base_download_path <- "CMIP6"  # 设置保存路径

# 确保主目录存在
if (!dir.exists(base_download_path)) {
  dir.create(base_download_path)
}

download_data <- function(model, ssp, time_range) {
  ssp_folder <- file.path(base_download_path, model, paste0("ssp", ssp), time_range)
  dir.create(ssp_folder, recursive = TRUE, showWarnings = FALSE)  # 创建文件夹
  
  for (var in variables) {
    # 构建文件名和下载 URL
    outf <- paste0("wc2.1_5m_", var, "_", model, "_ssp", ssp, "_", time_range, ".tif")
    durl <- paste0("https://geodata.ucdavis.edu/cmip6/5m/", model, "/ssp", ssp, "/", outf)
    poutf <- file.path(ssp_folder, outf)
    
    # 检查文件是否存在并下载
    if (file.exists(poutf)) {
      message(paste("File already exists:", poutf))
    } else {
      response <- try(download.file(durl, poutf, mode = "wb"), silent = TRUE)
      if (inherits(response, "try-error")) {
        message(paste("Failed to download:", durl))
      } else {
        message(paste("Downloaded:", var, "under SSP", ssp, "for model", model, "for period", time_range))
      }
    }
  }
}

# 循环处理模型
for (model in models) {
  for (ssp in scenarios) {
    for (time_range in time_ranges) {
      download_data(model, ssp, time_range)
    }
  }
}
