import styled from "styled-components";
import { StyledMenuItemProps } from "./types";

export const StyledMenuItemContainer = styled.div<StyledMenuItemProps>`
  position: relative;

  ${({ $isActive, $variant, theme }) =>
    $isActive &&
    $variant === "subMenu" &&
    `
      &:after{
        content: "";
        position: absolute;
        height: 5px;
        width: 100%;
        background-color: ${theme.colors.tertiary};
        border-radius: 15px;
        
      }
    `};
    
`;


const StyledMenuItem = styled.a<StyledMenuItemProps>`
  position: relative;
  display: flex;
  align-items: center;
  border-radius:80px;
  background: ${({ theme, $isActive }) => ($isActive ? theme.colors.tertiary : '')};
  color: ${({ theme, $isActive }) => ($isActive ? theme.colors.secondary : theme.colors.textSubtle)};
  font-size: 16px;
  font-weight: ${({ $isActive }) => ($isActive ? "600" : "400")};
  //border: ${({ theme, $isActive }) => ($isActive ? '' : '1px solid #FF10F0')};
  

  ${({ $statusColor, theme }) =>
    $statusColor &&
    `
    &:after {
      content: "";
      border-radius: 100px;
      background: ${theme.colors[$statusColor]};
      height: 10px;
      width: 16px;
      margin-left: 12px;
    }
  `}

  ${({ $variant }) =>
    $variant === "default"
      ? `
    padding: 2px 30px;
    height: 48px;
  `
      : `
    padding: 4px 20px 0px 15px;
    height: 42px;
    
  `}

  &:hover {
    background: ${({ theme }) => theme.colors.tertiary};
  
    ${({ $variant }) => $variant === "default" && "border-radius: 80px;"};
  }
`;

export default StyledMenuItem;
