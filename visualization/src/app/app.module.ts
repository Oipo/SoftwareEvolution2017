import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { D3Service } from 'd3-ng2-service';

import { AppComponent } from './app.component';
import { TreemapComponent } from './treemap/treemap.component';
import { BundlingComponent } from './bundling/bundling.component';


@NgModule({
  declarations: [
    AppComponent,
    TreemapComponent,
    BundlingComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [D3Service],
  bootstrap: [AppComponent]
})
export class AppModule { }
