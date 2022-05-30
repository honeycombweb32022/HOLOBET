import { createGlobalStyle } from 'styled-components'
import { PancakeTheme } from '@pancakeswap/uikit'

declare module 'styled-components' {
  /* eslint-disable @typescript-eslint/no-empty-interface */
  export interface DefaultTheme extends PancakeTheme {}
}

const GlobalStyle = createGlobalStyle`
  * {
    font-family: 'Kanit', sans-serif;
  }
  body {
    //background-color: ${({ theme }) => theme.colors.background};
    background: rgba(0, 0, 0, 0.9);
    background-image: url('/images/holobet-bg.png');
    
    background-repeat: no-repeat;
    background-position: 50% 0;
    img {
      height: auto;
      max-width: 100%;
    }
  }
  .jfNuus {
    color: #000000 !important;
  }
  .fmqgcf {
    background: rgba(255, 255, 255, 0.2) !important;
    border: 1px solid #FFFFFF;
    box-sizing: border-box;
    backdrop-filter: blur(74px);
  }
  .fGFIPp:after {
    bottom: none !important;
  }
  .hghKHe {
    color: #FFFFFF !important;
  }
  .ioekUo {
    color: #FFFFFF !important;
  }
  .jOjBDl {
    background: none !important;
  }
 // .bbDncm {
   // color: #FFFFFF !important;
 // }
  .fsxKZR {
    color: #FFFFFF !important;
  }
  .btbcTB, .iiXnjK, .hdxpdY, .fMFjuq {
    background: linear-gradient(100.41deg, #FF10F0 -16.67%, #06048C 83.33%) !important;
  }
  .ftVuor {
    background: linear-gradient(100.41deg, #FF10F0 -16.67%, #06048C 83.33%) !important;
  }
  .gUOZnN {
    background: linear-gradient(100.41deg, #FF10F0 -16.67%, #06048C 83.33%) !important;
  }
  .ddfuHg {
    background: rgba(255, 255, 255, 0.2) !important;
    box-sizing: border-box;
    backdrop-filter: blur(74px);
  }
  .djvGqz {
    color: #FFFFFF !important;
  }
  .holobet-btn {
    background: linear-gradient(100.41deg, #FF10F0 -16.67%, #06048C 83.33%) !important;
  }
  .iYEXmh svg {
    fill: #FFFFFF;
  }
`

export default GlobalStyle
