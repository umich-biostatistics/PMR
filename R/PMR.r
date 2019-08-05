
#' PMR model with individual level data
#'
#' Fit the probabilistic MR model with individual level data while accounting for 
#' the correlated instruments and horizontal pleiotropy in TWAS framework.
#'
#' @param yin standardized exposure vector (e.g. gene expression in TWAS).
#' @param zin standardized complex trait vector.
#' @param x1in standardized cis-genotype matrix in eQTL data.
#' @param x2in standardized cis-genotype matrix in GWAS data.
#' @param gammain indicator variable for constrained PMR model, with 1 for the null 
#' model that there is no horiozntal pleiotropy.
#' @param alphain indicator variable for constrained PMR model, with 1 for the null 
#' model that there is no causal effect.
#' @param max_iterin The maximum iteration.
#' @param epsin The convergence tolerance of the absolute value of the difference 
#' between the nth and (n+1)th loglikelihood.
#' 
#' @return a list of estimates of model parameters, including the causal effect 
#' \code{alpha}, the horizontal pleiotropy effect \code{gamma}, and the two 
#' corresponding p values
#' 
#' @author Zhongshang Yuan, Xiang Zhou.
#' 
#' @examples 
#' data(Exampleindividual.rda)
#' attach(Exampleindividual.rda)
#' fmH1 = PMR_individual(yin=x, zin=y, x1in=zx, x2in=zy,gammain=0,alphain = 0,max_iterin =1000,epsin=1e-5)
#' alpha<-fmH1$alpha
#' gamma<-fmH1$gamma
#' fmH0gamma = PMR_individual(yin=x,zin= y, x1in=zx, x2in=zy,gammain=1, alphain = 0,max_iterin =1000,epsin=1e-5)
#' fmH0alpha = PMR_individual(yin=x, zin=y, x1in=zx, x2in=zy,gammain=0,alphain = 1,max_iterin =1000, epsin=1e-5)
#' loglikH1=max(fmH1$loglik,na.rm=T)
#' loglikH0gamma=max(fmH0gamma$loglik,na.rm=T)
#' loglikH0alpha=max(fmH0alpha$loglik,na.rm=T)
#' stat_alpha = 2 * (loglikH1 - loglikH0alpha)
#' pvalue_alpha = pchisq(stat_alpha,1,lower.tail=F)
#' stat_gamma = 2 * (loglikH1 - loglikH0gamma)
#' pvalue_gamma = pchisq(stat_gamma,1,lower.tail=F)
#' 
#' @export
#'

PMR_individual <- function(yin, zin, x1in, x2in, gammain, alphain, max_iterin, epsin) {
  
  # call Rcpp to carry out computation
  PMR_individual_rcpp(yin = yin, 
                      zin = zin, 
                      x1in = x1in, 
                      x2in = x2in, 
                      gammain = gammain, 
                      alphain = alphain, 
                      max_iterin = max_iterin, 
                      epsin = epsin)
  
}


#' PMR model with summary data
#'
#' Fit the probabilistic MR model with summary data while accounting for the 
#' correlated instruments and horizontal pleiotropy in TWAS framework.
#'
#' @param betaxin the cis-SNP effect size vector for one specific gene in eQTL 
#' data, which must be calculated based on both the standardized gene expression 
#' value and the standardized cis-genotype matrix.
#' @param betayin the cis-SNP effect size vector for one specific gene in GWAS 
#' data, which be calculated based on both the standardized complex trait value 
#' and the standardized cis-genotype matrix.
#' @param Sigma1sin the LD matrix in eQTL data.
#' @param Sigma2sin the LD matrix in GWAS data.Both \code{Sigma2sin} and \code{sigma1sin} are often the same from the reference panel.
#' @param samplen1 the sample size of eQTL data.
#' @param samplen2 the sample size of GWAS data.
#' @param gammain indicator variable for constrained model, with 1 for the null model that there is no horiozntal pleiotropy.
#' @param alphain indicator variable for constrained model, with 1 for the null model that there is no causal effect.
#' @param max_iterin The maximum iteration.
#' @param epsin The convergence tolerance of the absolute value of the difference between the nth and (n+1)th loglikelihood.
#' 
#' @return A list of estimates of model parameters, including the causal effect \code{alpha}, the horizontal pleiotropy effect \code{gamma}, and the two corresponding p values.
#' 
#' @author Zhongshang Yuan, Xiang Zhou.
#' 
#' @examples 
#' data(Examplesummary.rda)
#' attach(Examplesummary.rda)
#' fmH1=PMR_summary(betaxin=betax,betayin=betay,Sigma1sin=Sigma1,Sigma2sin=Sigma2,samplen1=n1,samplen2=n2,gammain=0,alphain=0,max_iterin =1000, epsin=1e-5)
#' fmH0alpha=PMR_summary(betaxin=betax,betayin=betay,Sigma1sin=Sigma1,Sigma2sin=Sigma2,samplen1=n1,samplen2=n2,gammain=0,alphain=1,max_iterin =1000, epsin=1e-5)
#' fmH0gamma=PMR_summary(betaxin=betax,betayin=betay,Sigma1sin=Sigma1,Sigma2sin=Sigma2,samplen1=n1,samplen2=n2,gammain=1,alphain=0,max_iterin =1000, epsin=1e-5)
#' loglikH1=max(fmH1$loglik,na.rm=T)
#' loglikH0alpha=max(fmH0alpha$loglik,na.rm=T)
#' loglikH0gamma=max(fmH0gamma$loglik,na.rm=T)
#' stat_alpha = 2 * (loglikH1 - loglikH0alpha)
#' pvalue_alpha = pchisq(stat_alpha,1,lower.tail=F)
#' stat_gamma = 2 * (loglikH1 - loglikH0gamma)
#' pvalue_gamma = pchisq(stat_gamma,1,lower.tail=F)
#' 
#' @export
#'

PMR_summary <- function(betaxin, betayin, Sigma1sin, Sigma2sin, samplen1, samplen2, gammain, alphain, max_iterin, epsin) {
  
  # call Rcpp to carry out computation
  PMR_summary_rcpp(betaxin = betaxin, 
                   betayin = betayin, 
                   Sigma1sin = Sigma1sin, 
                   Sigma2sin = Sigma2sin, 
                   samplen1 = samplen1, 
                   samplen2 = samplen2, 
                   gammain = gammain, 
                   alphain = alphain, 
                   max_iterin = max_iterin, 
                   epsin = epsin)
  
}